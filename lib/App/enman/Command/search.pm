# ABSTRACT: search repositories into the enman db
package App::enman::Command::search;
use App::enman -command;
use App::enman;
use LWP::Simple;
use Locale::TextDomain 'App-enman';
use JSON;

sub abstract { "search among available repositories and packages" }

sub description {
"searches among available repositories and packages in the Sabayon Remote Enman Database";
}

sub opt_spec {
    return (
        [
            "package|P",
"search among available packages in the Sabayon Community Repositories infrastructure"
        ],
        [ "quiet|q", "Quiet output" ],
    );
}

sub validate_args {
    my ( $self, $opt, $args ) = @_;

    # we need at least one argument beyond the options; die with that message
    # and the complete "usage" text describing switches, etc
    $self->usage_error("too few arguments") unless @$args;
}

sub execute {
    my ( $self, $opt, $args ) = @_;
    App::enman->instance->loglevel("quiet") if $opt->{quiet};
    my $query = join( "", @{$args} );
    $self->usage_error("print help")
      if ( $query eq "--help" or $query eq "-h" );
    $opt->{package} ? package_search($query) : repository_search($query);

}

sub package_search() {
    my $query = join( "", @_ );
    App::enman->instance->info(
        __x(
            "Searching '{query}' package on the Enman db...", query => $query
        )
    ) if App::enman->instance->loglevel ne "quiet";
    my @matches = &pkg_search($query);
    App::enman->instance->fatal(
        __x( "No matches for '{query}'", query => $query ) )
      if @matches == 0;
    App::enman->instance->notice(
        __x(
            "{matches} results for {query}",
            matches => scalar(@matches),
            query   => $query
        )
    ) if App::enman->instance->loglevel ne "quiet";
    App::enman->instance->notice( "=" x 6 )
      if App::enman->instance->loglevel ne "quiet";
    foreach my $match (@matches) {
        App::enman->instance->notice(
            __x(
                "{package} - repository: {repository} ({arch})",
                repository => $match->[0],
                package    => $match->[1],
                arch       => $match->[2]
            )
        );
    }
}

sub repository_search() {
    my $query = join( "", @_ );
    if ( $query ne "" ) {
        App::enman->instance->info(
            __x( "Searching '{query}' on the Enman Database", query => $query )
        ) if App::enman->instance->loglevel ne "quiet";
    }
    else {
        App::enman->instance->info(
            __x("Listing all repositories available remotely") )
          if App::enman->instance->loglevel ne "quiet";
    }

    my @matches = &db_search($query);
    App::enman->instance->fatal(
        __x( "No matches for '{query}'", query => $query ) )
      if @matches == 0;
    App::enman->instance->notice(
        __x(
            "{matches} results for {query}",
            matches => scalar(@matches),
            query   => $query
        )
    ) if ( $query ne "" );
    App::enman->instance->notice( "=" x 6 )
      if App::enman->instance->loglevel ne "quiet";
    foreach my $match (@matches) {
        if ( App::enman->instance->loglevel eq "quiet" ) {
            App::enman->instance->info( $match->[0] );
        }
        else {
            App::enman->instance->notice(
                __x(
                    "Repository: {repository} - \"{description}\"",
                    repository  => $match->[0],
                    description => $match->[1]
                )
            );
        }
    }
}

sub pkg_search() {
    my $query = join( "", @_ );
    if ( !head( App::enman::METADATA_DB() ) ) {
        App::enman->instance->info(
            __x("Metadata not available online. Please try later") );
        return [];
    }
    my @matches;
    my $metadata_db = get( App::enman::METADATA_DB() );

    # Remove JSONP cruft
    $metadata_db =~ s/^parsePackages\(//g;
    $metadata_db =~ s/\)//g;

    $db = decode_json($metadata_db);
    foreach my $entry (@$db) {
        if ( $entry->{package} =~ /$query/ ) {
            push( @result,
                [ $entry->{repository}, $entry->{package}, $entry->{arch} ] );
        }
    }
    return @result;
}

sub db_search {
    my ($string) = shift;
    my $enman = get( App::enman::ENMAN_DB() );
    my @enman_db = split( /\n/, $enman );
    my @matches;
    foreach my $repo (@enman_db) {
        my ( $repo_name, $repo_url ) = split( ':', $repo, 2 );
        my $repo_url_db = get($repo_url);
        my @local_db    = split( /\n/, $repo_url_db );
        my $description = "None found";
        foreach my $line (@local_db) {
            if ( $line =~ /desc =(.*)/ ) {
                $description = $1;
                $description =~ s/^\s+|\s+$//g;
            }
        }

        #if exact match return only the unique(should be) result
        if ( $repo_name eq $string ) {
            return ( [ $repo_name, $description ] );
        }

        #enabling regex search, not quoted
        elsif ( $repo =~ /$string/i ) {
            push( @matches, [ $repo_name, $description ] );
        }
    }
    return @matches;
}

sub db_search_config {
    my ($string) = shift;
    my $enman = get( App::enman::ENMAN_DB() );
    my @enman_db = split( /\n/, $enman );
    my @matches;
    foreach my $repo (@enman_db) {
        my ( $repo_name, $repo_url ) = split( ':', $repo, 2 );

        #if exact match return only the unique(should be) result
        if ( $repo_name eq $string ) {
            return ( [ $repo_name, $repo_url ] );
        }

        #enabling regex search, not quoted
        elsif ( $repo =~ /$string/i ) {
            push( @matches, [ $repo_name, $repo_url ] );
        }
    }
    return @matches;
}
1;
