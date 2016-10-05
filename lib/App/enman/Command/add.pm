# ABSTRACT: Adds an entropy repository to your system that matches your query string
package App::enman::Command::add;
use App::enman -command;
use LWP::Simple;
use Locale::TextDomain 'App-enman';
use App::enman;

sub abstract { "Add repositories in the system" }

sub description {
    "Fetches and install remote repositories definitions";
}

sub opt_spec {
    return ( [ "quiet|q", "Quiet output" ], );
}

sub execute {
    my ( $self, $opts, $args ) = @_;
    App::enman->instance->loglevel("quiet") if $opt->{quiet};

    error( __("You must run enman with root permissions") ) and return 1
      if $> != 0;
    App::enman->instance->info(
        __x(
            "Repository '{repository}' already present in your system",
            repository => "@{$args}"
        )
      )
      and return 1
      if -e App::enman::ETPREPO_DIR() . App::enman::ETPSUFFIX() . "@{$args}";
    error( __("You must supply the repository name") ) and return 1
      if @{$args} == 0;

    my @results = &App::enman::Command::search::db_search_config( @{$args} );
    if ( @results > 1 ) {
        App::enman->instance->info(
            __x(
                "'{repository}' repository matches more than one:",
                repository => "@{$args}"
            )
        );
        foreach my $match (@results) {
            App::enman->instance->notice(
                __x( "Repository: {repository}", repository => $match->[0] ) );

            App::enman->instance->info(
                "\t"
                  . __x(
                    "Configuration file: {config}", config => $match->[0]
                  )
            );
        }
        return 1;
    }
    elsif ( !$results[0] ) {
        App::enman->instance->notice(
            __x( "No matches for '{repository}'", repository => "@{$args}" ) );
        return 1;
    }
    App::enman->instance->info(
        __x(
            "Installing '{repository}' in your system",
            repository => "@{$args}"
        )
    );
    my $repo_name = App::enman::ETPSUFFIX() . $results[0]->[0];
    my $repo      = get( $results[0]->[1] );
    open my $EREPO, ">" . App::enman::ETPREPO_DIR() . $repo_name
      or die( __x( "cannot write the repository file: {error}", error => $! ) );
    binmode $EREPO, ":utf8";
    print $EREPO $repo;
    close($EREPO);
    App::enman->instance->info(
        __x( "{repo} installed in your system", repo => "@{$args}" ) );
}
1;
