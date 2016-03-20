use strict;
use Test::More 0.98;
use App::enman::Command::search;

is_deeply(&App::enman::Command::search::search("spike"),['spike','https://github.com/Spike-Pentesting/enman-db/raw/master/repositories/spike'], "Search");
done_testing;

