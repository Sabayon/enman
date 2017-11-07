package App::enman;
use strict;
use warnings;
use utf8;

use App::Cmd::Setup -app;
use constant ETPREPO_DIR => $ENV{ETPREPO_DIR}
  || "/etc/entropy/repositories.conf.d/";
use constant ENMAN_DB => $ENV{ENMAN_DB}
  || "https://raw.githubusercontent.com/Sabayon/enman-db/master/enman.db";
use constant METADATA_DB => $ENV{METADATA_DB}
  || "http://mirror.de.sabayon.org/community/metadata.json";
use constant ETPSUFFIX => "entropy_enman_";
our $VERSION = "1.3.6";
my $singleton;
use Term::ANSIColor;
use Encode;
use Locale::TextDomain 'App-enman';
use Locale::Messages qw(bind_textdomain_filter);

BEGIN {
    $ENV{OUTPUT_CHARSET} = 'UTF-8';
    bind_textdomain_filter 'App-enman' => \&Encode::decode_utf8;
}

sub new {
    $singleton ||= shift->SUPER::new(@_);
    $singleton->{LOG_LEVEL} = "info" if !$singleton->{LOG_LEVEL};
    $singleton;
}

sub error {
    my $self = shift;
    my @msg  = @_;
    if ( $self->{LOG_LEVEL} eq "info" ) {
        print STDERR color 'bold red';
        print STDERR encode_utf8('☢☢☢ ☛    ');
        print STDERR color 'bold magenta';
        print STDERR encode_utf8(join( "\n", @msg )), "\n";
        print STDERR color 'reset';
    }
    elsif ( $self->{LOG_LEVEL} eq "quiet" ) {
        print encode_utf8(join( "\n", @msg )), "\n";
    }
}

sub fatal {
    &error(@_);
    exit 1;
}

sub info {
    my $self = shift;
    my @msg = @_;
    if ( $self->{LOG_LEVEL} eq "info" ) {
        print color 'bold green';
        print encode_utf8('╠   ');
        print color 'bold blue';
        print encode_utf8(join( "\n", @msg )), "\n";
        print color 'reset';
    }
    elsif ( $self->{LOG_LEVEL} eq "quiet" ) {
        print encode_utf8(join( "\n", @msg )), "\n";
    }
}

sub notice {
    my $self = shift;
    my @msg  = @_;
    if ( $self->{LOG_LEVEL} eq "info" ) {
        print STDERR color 'bold yellow';
        print STDERR encode_utf8('☛   ');
        print STDERR color 'bold green';
        print STDERR encode_utf8(join( "\n", @msg )), "\n";
        print STDERR color 'reset';
    }
    elsif ( $self->{LOG_LEVEL} eq "quiet" ) {
        print STDERR encode_utf8(join( "\n", @msg )), "\n";
    }
}

sub loglevel {
    my $self = shift;

    $self->{LOG_LEVEL} = $_[0] if $_[0];

    return $self->{LOG_LEVEL};
}
*instance = \&new;

1;
__END__

=encoding utf-8

=head1 NAME

enman - a layman equivalent for entropy repositories

=head1 SYNOPSIS

    $ enman add "somerepo"
    $ enman remove "somerepo"
    $ enman search "something"
    $ enman search -P|--package "app-foo/foobar" # shows packages in the SCR repositories
    $ enman list
    $ enman list -A|--available # lists available remote repositories in SCR


    # get help:

    $ enman help
    $ enman commands

=head1 DESCRIPTION

enman is the equivalent of layman for Sabayon, it allows you to easily add/remove/search repositories into your sabayon machine.

=head1 COMMANDS

=head2 add
It search and add the repository to your machine

=head2 remove
It removes the repository from your machine

=head2 search
It search and list the repository that matches your query, if C<--package> or C<-P> is supplied as option, it searchs among the SCR remote database

=head2 list
It prints the repositories installed in the system, if C<--available> or C<-A> is supplied as option, it lists the available SCR repositories.

=head1 FOR REPOSITORY MANTAINERS
If you want your repository available thru enman, send a PR on the L<Enman-db GitHub repository|https://github.com/Sabayon/enman-db>
