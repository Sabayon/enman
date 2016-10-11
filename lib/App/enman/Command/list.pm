# ABSTRACT: list installed repositories
package App::enman::Command::list;
use App::enman -command;
use App::enman::Command::search;
use Locale::TextDomain 'App-enman';
use App::enman;
sub abstract { "List repositories installed in the system" }

sub description {
    "Lists repositories file installed in the machine";
}

sub opt_spec {
    return (
        [
            "available|A",
            "Shows the list of the available remote repositories"
        ],
        [ "installed|I", "Shows the list of the installed repositories" ],
        [ "quiet|q",     "Quiet output" ],
    );
}

sub validate_args {
    my ( $self, $opt, $args ) = @_;

    # no args allowed but options!
    $self->usage_error("No args allowed") if @$args;
}

sub execute {
    my ( $self, $opt, $args ) = @_;
    App::enman->instance->loglevel("quiet") if $opt->{quiet};
    if ( $opt->{available} ) {
        &App::enman::Command::search::repository_search("");
    }
    elsif ( $opt->{installed} ) {
        local_repositories();
    }
    else {
        $self->usage_error(
            __("You should at least supply --installed or --available") );
    }
}

sub local_repositories {
    App::enman->instance->fatal(
        __("You must run enman with root permissions") )
      if $> != 0;
    opendir( my $dir, App::enman::ETPREPO_DIR() ) or die $!;

    my @enman_repos;
    while ( my $file = readdir($dir) ) {
        next if ( $file =~ m/^\.|\.example|README/ );
        push( @enman_repos, $file ) if $file =~ App::enman::ETPSUFFIX();
    }
    App::enman->instance->fatal(
        __("No repositories were installed with enman") )
      if ( @enman_repos == 0 );

    App::enman->instance->info( __("Repositories enabled with enman:") )
      if App::enman->instance->loglevel ne "quiet";
    my $etpsuffix = App::enman::ETPSUFFIX;    #faster since gets compiled
    foreach my $repo (@enman_repos) {
        $repo =~ s/${etpsuffix}//g;
        App::enman->instance->notice(
            ( ( App::enman->instance->loglevel eq "quiet" ) ? "" : "\t" )
            . $repo );
    }

    closedir($dir);
}
1;
