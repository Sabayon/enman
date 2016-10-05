# ABSTRACT: list installed repositories
package App::enman::Command::list;
use App::enman -command;
use App::enman::Utils;
use App::enman::Command::search;
use Locale::TextDomain 'App-enman';

sub abstract { "List repositories installed in the system" }

sub description {
    "Lists repositories file installed in the machine";
}

sub opt_spec {
    return (
        [
            "availables|A",
            "Shows the list of the available remote repositories"
        ],
    );
}

sub validate_args {
    my ( $self, $opt, $args ) = @_;

    # no args allowed but options!
    $self->usage_error("No args allowed") if @$args;
}

sub execute {
    my ( $self, $opt, $args ) = @_;
    $opt->{availables}
      ? &App::enman::Command::search::repository_search("")
      : local_repositories();
}

sub local_repositories {
    error( __("You must run enman with root permissions") ) and return 1
      if $> != 0;
    opendir( my $dir, App::enman::ETPREPO_DIR() ) or die $!;

    info( __("Repositories available in your system: ") );
    my @enman_repos;
    while ( my $file = readdir($dir) ) {
        next if ( $file =~ m/^\.|\.example|README/ );
        push( @enman_repos, $file ) if $file =~ App::enman::ETPSUFFIX();
        notice "\t$file";
    }
    info( __("No repositories were installed with enman") ) and return 1
      if ( @enman_repos == 0 );

    info(
        __(
"Repositories enabled with enman: (so you can remove it with enman <name>)"
        )
    );
    my $etpsuffix = App::enman::ETPSUFFIX;    #faster since gets compiled
    foreach my $repo (@enman_repos) {
        $repo =~ s/${etpsuffix}//g;
        notice "\t$repo";
    }

    closedir($dir);
}
1;
