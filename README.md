# NAME

App::enman

# VERSION

version 1.1

# SYNOPSIS

    $ enman add "somerepo"
    $ enman remove "somerepo"
    $ enman search "something"
    $ enman search -P|--package "app-foo/foobar" # shows packages in the SCR repositories
    $ enman list
    $ enman list -A|--availables # lists available remote repositories in SCR


    # get help:

    $ enman help
    $ enman commands

# DESCRIPTION

enman is the equivalent of layman for Sabayon, it allows you to easily add/remove/search repositories into your sabayon machine.

# COMMANDS

## add
It search and add the repository to your machine

## remove
It removes the repository from your machine

## search
It search and list the repository that matches your query, if `--package` or `-P` is supplied as option, it searchs among the SCR remote database

Searchs

## list
It prints the repositories installed in the system, if `--availables` or `-A` is supplied as option, it lists the available SCR repositories.

# FOR REPOSITORY MANTAINERS
If you want your repository available thru enman, send a PR on the [Enman-db GitHub repository](https://github.com/Sabayon/enman-db)

# AUTHOR

mudler <mudler@sabayon.org>

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2016 by Ettore Di Giacinto.

This is free software, licensed under:

    The GNU General Public License, Version 3, June 2007
