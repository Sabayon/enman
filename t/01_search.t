use strict;
use Test::More 0.98;
use App::enman::Command::search;

is_deeply(&App::enman::Command::search::search("community"),['community','https://github.com/Sabayon/enman-db/raw/master/repositories/community'], "Search");
done_testing;

