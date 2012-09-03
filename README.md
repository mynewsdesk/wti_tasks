# WTI tasks

## Provides Rake tasks for managing projects on WebTranslateIt.

Each project on WebTranslateIt has it's corresponding wti configuration file.
The default is `.wti`. Name subsequent files `.wti-[project name]`, and this gem will
be able to pick them up.

The gem looks for `.wti*` files, and defines wti:pull and wti:push tasks for each
of them. If you have a `.wti` and a `.wti-project1` file, you will have the
following rake tasks defined:

    wti:help
    wti:pull:all
    wti:pull:default
    wti:pull:project1
    wti:push:all
    wti:push:default
    wti:push:project1

Running `rake wti:pull:default` will run the  command `wti pull -c .wti`. Running
`rake wti:pull:all` will run all wti:pull:[project] tasks consequtively.

## Options

You can provide additional options for the resulting `wti` command by adding
them after an `--` to indicate to rake that you have no further options for it.
For example, to run:

    wti pull -c .wti --force -locale en

You can run the rake task as:

    rake wti:pull:default -- --force --locale en

Help on this is provided by the task `wti:help`.