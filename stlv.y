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


// #define CROSS(v1, v2, n) \
//   (n)[0] =   (v1)[1] * (v2)[2] - (v2)[1] * (v1)[2];\
//   (n)[1] = -((v1)[0] * (v2)[2] - (v2)[0] * (v1)[2]);\
//   (n)[2] =   (v1)[0] * (v2)[1] - (v2)[0] * (v1)[1]

// #define NORM(x) ((x[0]) * (x[0]) + (x[1]) * (x[1]) + (x[2]) * (x[2]))


REAL vol;
void init(){vol=0.;}


void incr_facet(
  REAL n1, REAL n2, REAL n3,
  REAL x1, REAL x2, REAL x3,
  REAL y1, REAL y2, REAL y3,
  REAL z1, REAL z2, REAL z3){

  REAL incr = (-1*x3*y2*z1 + x2*y3*z1 + x3*y1*z2 - x1*y3*z2 - x2*y1*z3 + x1*y2*z3)/6.;

  // REAL x[3] = {x1-x2,y1-y2,z1-z2};
  // REAL y[3] = {x1-x3,y1-y3,z1-z3};
  // REAL zz[3]; CROSS(x,y,zz);
  // REAL A = NORM(zz)/2;
  // REAL incr = 1./3. * (y1*n1+y2*n2+y3*n3)*A;

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
