use strict;
use Test::More 0.98;
use App::enman::Command::search;
is(
    (&App::enman::Command::search::pkg_search("telegram"))[0][0],
    'community',
    "Searching 'telegram' package inside metadata"
);
is_deeply(
    &App::enman::Command::search::db_search("community"),
    [ 'community', 'community Repository' ],
    "Searching community repository inside repositories list"
);
is_deeply(
    &App::enman::Command::search::db_search("pentesting"),
    [ 'pentesting', 'Pentesting Repository' ],
    "Searching pentesting repository inside repositories list"
);
is_deeply(
    &App::enman::Command::search::db_search_config("community"),
    [
        'community',
        'https://github.com/Sabayon/enman-db/raw/master/repositories/community'
    ],
    "Searching config of community repository inside repositories list"
);

done_testing;
