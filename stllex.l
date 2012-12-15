/* THIS IS latex.l */
%{ /* A LEX FOR PART 3 OF THE PROJECT WHERE VERBATIM WORKS */
#include "stlv.h"
%}


%option outfile="stllex.c" header-file="stllex.h"

ws		[ \t\n]+
number          -?(([0-9]+)|([0-9]*\.[0-9]+)([eE][-+]?[0-9]+)?)
punc            (\.|\,|\!|\?|\;|\:|\_)
word		({punc}|[a-zA-Z0-9])*

/*notws           [^ \n\t]+*/

/*printf(" %s \n", yytext);*/

%%
{number}                {yylval.val = atof(yytext);return(NUM);}

"solid"	                {return(SOLID);}
"endsolid"              {return(ENDSOLID);}
"outer"	                {return(OUTER);}
"loop"	                {return(LOOP);}
"endloop"               {return(ENDLOOP);}
"vertex"                {return(VERTEX);}
"facet"	                {return(FACET);}
"normal"                {return(NORMAL);}
"endfacet"              {return(ENDFACET);}

{ws}			{return(WS);}
{word}			{return(NOTWS);}
%%

