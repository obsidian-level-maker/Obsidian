%option noyywrap noinput nounput nounistd

%{
#include <stdio.h>
#include "nodes.h"
%}

%%

"%year" { year(); }
"%month" { month(); }
"%day" { day(); }
"%hour" { hour(); }
"%minute" { minute(); }
"%second" { second(); }
"%version" { version(); }
"%game" { game(); }
"%theme" { theme(); }
"%count" { count(); }
"%Y" { year(); }
"%M" { month(); }
"%D" { day(); }
"%h" { hour(); }
"%m" { minute(); }
"%s" { second(); }
"%v" { version(); }
"%g" { game(); }
"%t" { theme(); }
"%c" { count(); }
. { printf("%s", yytext);}
<<EOF>> return tokEof;
