# ABSTRACT: remove an entropy repository from your system
package App::enman::Command::remove;
use App::enman -command;
use Locale::TextDomain 'App-enman';
use App::enman;

sub abstract { "Removes repositories in the system installed by enman" }

sub description {
    "Removes repositories in the system installed by enman";
}

sub opt_spec {
    return ( [ "quiet|q", "Quiet output" ], );
}

sub execute {
    my ( $self, $opt, $args ) = @_;
    App::enman->instance->loglevel("quiet") if $opt->{quiet};
    App::enman->instance->error(
        __("You must run enman with root permissions") )
      and return 1
      if $> != 0;

    my $repo = App::enman::ETPREPO_DIR() . App::enman::ETPSUFFIX() . "@{$args}";
    if ( -e $repo ) {
        App::enman->instance->info(
            __x(
                "removing '{repo_name}' - '{repository}'",
                repo_name  => "@{$args}",
                repository => $repo
            )
        );
        unlink($repo);
    }
    else {
        App::enman->instance->error(
            __x(
"There is no repository '{repository}' installed in your system",
                repository => "@{$args}"
            )
        );
    }
}
1;
