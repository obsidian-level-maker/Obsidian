project(obsidian_acc LANGUAGES C VERSION 0.1.0)

add_library(obsidian_acc
    acc.c
    common.h
    error.c
    error.h
    misc.c
    misc.h
    parse.c
    parse.h
    pcode.c
    pcode.h
    strlist.c
    strlist.h
    symbol.c
    symbol.h
    token.c
    token.h
)
