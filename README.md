vim-sdcv
========

A not-invented-here sdcv plugin for Vim.

Usage
-----

sdcv.vim defines the command `Sdcv` which accepts words and phrases as
arguments.  Multiple words can be searched at once.  For example,

    Sdcv star planet moon

will show the definitions of "star", "planet", and "moon".  Multi word
phrases (e.g., "rain cats and dogs") can also be passed, but spaces need
to be escaped (and not quoted):

    Sdcv rain\ cats\ and\ dogs

To use sdcv as the `'keywordprg'`:

    set keywordprg=:Sdcv

### Custom Dictionaries

The command `Sdcv` passes all its arguments to the sdcv executable
directly and thus, custom dictionaries can also be selected using
the `--use-dict` (or `-u`) option like one would usually do with sdcv.
Alternately, the global variable `g:sdcv_dictionaries` can be used:

    let g:sdcv_dictionaries = ['Moby Thesaurus', 'Wordnet']

### Filters

sdcv's output may not always be very pretty, and thus, it makes sense to
filter it.  The variable `g:sdcv_filter` can be defined to use a custom
filter program, e.g.,

    let g:sdcv_filter = 'sdcv-prettify'

License
-------

Public domain.
