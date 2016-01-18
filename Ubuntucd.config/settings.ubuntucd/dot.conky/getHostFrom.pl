#!/usr/bin/perl

use strict; use warnings;
use Inline C => 'EOC';

#include<utmp.h>

/* Inline will export this to Perl.
 * Takes a scalar, returns a scalar.
 */
SV* hostordisplay( SV* sv_tty )
{
   /* Good C, declare variables up front */
   /* utmp.h deals with struct utmp, which holds
    * the info we want. We need a pointer to hold
    * the info we get out, and a real struct to
    * specify the info to match against.
    */
   struct utmp *up;
   struct utmp ut;
   char * tty;

   /* grab the string (char *) version of our scalar */
   tty = SvPV_nolen( sv_tty );
   /* and put it into our matching struct utmp */
   strncpy(ut.ut_line, tty, UT_LINESIZE);

   /* open the utmp file at the beginning */
   setutent();
   /* and get a pointer to matching struct utmp */
   up = getutline( &ut );
   /* gotta check if it succeeded */
   if ( up == NULL )
   {
      /* return undef if it failed */
      return &PL_sv_undef;
   }
   /* close the utmp file again */
   endutent();

   /* return a new scalar with the value of
    * of the remote host or the display (on my
    * system). Using 0 for length param makes perl
    * use strlen to find the length.
    */
   return newSVpv( up->ut_host, 0 );
}

(my $tty = readlink('/proc/self/fd/0') || 'notty') =~ s{^/dev/}{};
print "You are logged in from ",
   hostordisplay($tty) || 'nowhere', "\n";
