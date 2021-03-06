%{

#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#ifdef SINGLE
#define REAL float
#else
#define REAL double
#endif


#include "stllex.c"
void yyerror(const char *s);
extern int yyval;


#define CROSS(v1, v2, n) \
  (n)[0] =   (v1)[1] * (v2)[2] - (v2)[1] * (v1)[2];\
  (n)[1] = -((v1)[0] * (v2)[2] - (v2)[0] * (v1)[2]);\
  (n)[2] =   (v1)[0] * (v2)[1] - (v2)[0] * (v1)[1]

#define NORM2(x) ((x[0]) * (x[0]) + (x[1]) * (x[1]) + (x[2]) * (x[2]))


REAL vol;
void init(){vol=0.;}


void incr_facet(
  REAL n1, REAL n2, REAL n3,
  REAL i1, REAL i2, REAL i3,
  REAL j1, REAL j2, REAL j3,
  REAL k1, REAL k2, REAL k3){


  /* REAL x[3] = {i1-j1,i2-j2,i3-j3}; */
  /* REAL y[3] = {i1-k1,i2-k2,i3-k3}; */
  /* REAL zz[3]; CROSS(x,y,zz); */
  /* REAL A = sqrt(NORM2(zz))/2; */
  /* REAL incr = 1./3. * (i1*n1+i2*n2+i3*n3)*A; */

  REAL incr = (-1*k1*j2*i3 + j1*k2*i3 + k1*i2*j3 - i1*k2*j3 - j1*i2*k3 + i1*j2*k3)/6.;

  vol+=incr;
}


%}

%error-verbose

%output  "stlv.c"
%defines "stlv.h"

%union 
   {
      REAL val;
   }


%start stl

%token SOLID OUTER LOOP VERTEX FACET ENDFACET WS NOTWS NUM ENDSOLID ENDLOOP NORMAL

%type <val> NUM

%%


stl:    SOLID WS NOTWS WS facets WS ENDSOLID WS NOTWS
   | WS SOLID WS NOTWS WS facets WS ENDSOLID WS NOTWS WS
   |    SOLID WS NOTWS WS facets WS ENDSOLID WS NOTWS WS
   | WS SOLID WS NOTWS WS facets WS ENDSOLID WS NOTWS
   ;

facets: facets WS facet
   | facet
   ;

facet: FACET WS NORMAL WS NUM WS NUM WS NUM WS 
        OUTER WS LOOP WS
          VERTEX WS NUM WS NUM WS NUM WS
          VERTEX WS NUM WS NUM WS NUM WS
          VERTEX WS NUM WS NUM WS NUM WS
        ENDLOOP WS
       ENDFACET
         {
           incr_facet($5,$7,$9,
                      $17,$19,$21,
                      $25,$27,$29,
                      $33,$35,$37);
         }
    ;
 
%%


void yyerror (const char *s) {
     fprintf (stderr, "%s\n", s);exit(1);
}

#ifndef STLV_LIB
main()
{
  init();
  yyparse();
  printf ("VOLUME = %.6e\n",vol);
  return 0;
}
#else
/* REAL getvolume(char *filename) */
/* { */
/*   init(); */
/*   yyparse(); */
/*   printf ("VOLUME = %.6e\n",vol); */
/*   return vol; */
/* } */
#endif
