use strict;
use Test::More 0.98;
use App::enman::Command::search;
is_deeply(&App::enman::Command::search::pkg_search("telegram"),['community','net-im/telegram-bin-0.10.11','amd64'], "Searching 'telegram' package inside metadata");
is_deeply(&App::enman::Command::search::db_search("community"),['community','community Repository'], "Searching community repository inside repositories list");
is_deeply(&App::enman::Command::search::db_search("pentesting"),['pentesting','Pentesting Repository'], "Searching pentesting repository inside repositories list");

done_testing;
