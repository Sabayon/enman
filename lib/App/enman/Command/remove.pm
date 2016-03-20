# ABSTRACT: remove an entropy repository from your system
package App::enman::Command::remove;
use App::enman -command;
use App::enman::Utils;
use Locale::TextDomain 'App-enman';

sub execute {
    my ( $self, $opt, $args ) = @_;
    error( __("You must run enman with root permissions") ) and return 1
        if $> != 0;

    my $repo
        = App::enman::ETPREPO_DIR() . App::enman::ETPSUFFIX() . "@{$args}";
    if ( -e $repo ) {
        info(
            __x("removing '{repo_name}' - '{repository}'",
                repo_name  => "@{$args}",
                repository => $repo
            )
        );
        unlink($repo);
    }
    else {
        error(
            __x("There is no repository '{repository}' installed in your system",
                repository => "@{$args}"
            )
        );
    }
}
1;
