package App::enman;
use strict;
use warnings;
use App::Cmd::Setup -app;
use constant ETPREPO_DIR => $ENV{ETPREPO_DIR}
  || "/etc/entropy/repositories.conf.d/";
use constant ENMAN_DB => $ENV{ENMAN_DB}
  || "https://raw.githubusercontent.com/Sabayon/enman-db/master/enman.db";
use constant METADATA_DB => $ENV{METADATA_DB}
  || "http://mirror.de.sabayon.org/community/metadata.json";
use constant ETPSUFFIX => "entropy_enman_";
our $VERSION = "1.2";
my $singleton;
use Term::ANSIColor;
use utf8;
use Encode;

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
        print STDERR encode_utf8('☢☢☢ ☛  ');
        print STDERR color 'bold white';
        print STDERR join( "\n", @msg ), "\n";
        print STDERR color 'reset';
    }
    elsif ( $self->{LOG_LEVEL} eq "quiet" ) {
        print join( "\n", @msg ), "\n";
    }
}

sub info {
    my $self = shift;

    my @msg = @_;
    if ( $self->{LOG_LEVEL} eq "info" ) {
        print color 'bold green';
        print encode_utf8('╠ ');
        print color 'bold white';
        print join( "\n", @msg ), "\n";
        print color 'reset';
    }
    elsif ( $self->{LOG_LEVEL} eq "quiet" ) {
        print join( "\n", @msg ), "\n";
    }
}

sub notice {
    my $self = shift;
    my @msg  = @_;
    if ( $self->{LOG_LEVEL} eq "info" ) {
        print STDERR color 'bold yellow';
        print STDERR encode_utf8('☛ ');
        print STDERR color 'bold white';
        print STDERR join( "\n", @msg ), "\n";
        print STDERR color 'reset';
    }
    elsif ( $self->{LOG_LEVEL} eq "quiet" ) {
        print STDERR join( "\n", @msg ), "\n";
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

Searchs

=head2 list
It prints the repositories installed in the system, if C<--available> or C<-A> is supplied as option, it lists the available SCR repositories.

=head1 FOR REPOSITORY MANTAINERS
If you want your repository available thru enman, send a PR on the L<Enman-db GitHub repository|https://github.com/Sabayon/enman-db>

=head1 LICENSE

Copyright (C) mudler.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

mudler E<lt>mudler@sabayon.orgE<gt>

=cut
