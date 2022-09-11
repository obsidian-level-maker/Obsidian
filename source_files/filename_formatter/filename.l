%option noyywrap noinput nounput nounistd

%{
#include <stdio.h>
#include "ff.h"
%}

%%

"%year" { year(); return 0; }
"%month" { month(); return 0; }
"%day" { day(); return 0; }
"%hour" { hour(); return 0; }
"%minute" { minute(); return 0; }
"%second" { second(); return 0; }
"%version" { version(); return 0; }
"%game" { game(); return 0; }
"%engine" { engine(); return 0; }
"%theme" { theme(); return 0; }
"%count" { count(); return 0; }
"%Y" { year(); return 0; }
"%M" { month(); return 0; }
"%D" { day(); return 0; }
"%h" { hour(); return 0; }
"%m" { minute(); return 0; }
"%s" { second(); return 0; }
"%v" { version(); return 0; }
"%g" { game(); return 0; }
"%e" { engine(); return 0; }
"%t" { theme(); return 0; }
"%c" { count(); return 0; }
. { raw_append(yytext); return 0; }
<<EOF>> return TOK_EOF;
