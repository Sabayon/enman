use strict;
use Test::More 0.98;

use_ok $_ for qw(
    App::enman
    App::enman::Utils
    App::enman::Command::add
    App::enman::Command::search
    App::enman::Command::remove
);

done_testing;

