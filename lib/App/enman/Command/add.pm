# ABSTRACT: Adds an entropy repository to your system that matches your query string
package App::enman::Command::add;
use App::enman -command;
use LWP::Simple;
use Locale::TextDomain 'App-enman';
use App::enman;
use File::Copy;

sub abstract {"Add repositories in the system"}

sub description {
    "Fetches and install remote repositories definitions";
}

sub opt_spec {
    return ( [ "quiet|q", "Quiet output" ], );
}

sub execute {
    my ( $self, $opts, $args ) = @_;
    App::enman->instance->loglevel("quiet") if $opt->{quiet};

    App::enman->instance->fatal(
        __("You must run enman with root permissions") )
        if $> != 0;
    App::enman->instance->fatal(
        __x("Repository '{repository}' already present in your system",
            repository => "@{$args}"
        )
        )
        if -e App::enman::ETPREPO_DIR()
        . App::enman::ETPSUFFIX()
        . "@{$args}";
    App::enman->instance->fatal( __("You must supply the repository name") )
        if @{$args} == 0;

    return add_single( @{$args} ) if is_url( ( @{$args} )[0] );

    my @results = &App::enman::Command::search::db_search_config( @{$args} );
    if ( @results > 1 ) {
        App::enman->instance->info(
            __x("'{repository}' repository matches more than one:",
                repository => "@{$args}"
            )
        );
        foreach my $match (@results) {
            App::enman->instance->notice(
                __x( "Repository: {repository}", repository => $match->[0] )
            );

            App::enman->instance->info(
                "\t"
                    . __x(
                    "Configuration file: {config}",
                    config => $match->[0]
                    )
            );
        }
        exit 1;
    }
    elsif ( !$results[0] ) {
        App::enman->instance->fatal(
            __x( "No matches for '{repository}'", repository => "@{$args}" )
        );
    }
    App::enman->instance->info(
        __x("Installing '{repository}' in your system",
            repository => "@{$args}"
        )
    );
    my $repo_name = App::enman::ETPSUFFIX() . $results[0]->[0];
    my $repo      = get( $results[0]->[1] );
    open my $EREPO, ">" . App::enman::ETPREPO_DIR() . $repo_name
        or App::enman->instance->fatal(
        __x( "cannot write the repository file: {error}", error => $! ) );
    binmode $EREPO, ":utf8";
    print $EREPO $repo;
    close($EREPO);
    App::enman->instance->info(
        __x( "{repo} installed in your system", repo => "@{$args}" ) );
}

# args: url [name]
sub add_single {
    my ( $url, $name ) = @_;
    my $normal = $name // last_path($url);
    my $dest = App::enman::ETPREPO_DIR() . App::enman::ETPSUFFIX() . $normal;
    return App::enman->instance->info(
        __x( "{repo} installed in your system", repo => $normal ) )
        if (
        system(
            "equo repo add '$normal' --desc $url --repo $url#bz2 --pkg $url")
        == 0
        && move( App::enman::ETPREPO_DIR() . App::enman::ESUFFIX() . $normal,
            $dest ) == 1
        );
    exit 1;
}

sub normalize {
    my $s = shift;
    $s =~ s/https?:\/\/(www\.)?//i;
    $s =~ s/\/|\./-/g;
    return $s;
}

sub last_path {
    my $s = shift;
    $s =~ m!([^/]*$)! and my $p = $1;
    return normalize($p);
}

sub is_url {
    shift
        =~ /https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,10}\b([-a-zA-Z0-9@:%_\+.~#?&=]*)/i
        ? 1
        : 0;
}

1;
