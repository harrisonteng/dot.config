/*
  $Id$

  [bug:]
  you can also use perl:
    1. perl -e '$big_endian = pack("L", 1) eq pack("N", 1);print "big-endian" if $big_endian;'
    2. perl -MConfig -e 'print "$Config{byteorder}\n";'
    3. echo -n I | od -to2 | head -n1 | cut -f2 -d" " | cut -c6 => 0 , big endian and 1, little endian
       The command above uses the fact that on a little endian system ASCII "I" has the octal value 000111,
       and on a big endian systems capital "i" character has the octal value 0444000.
       Therefore returning the last character is appropriate for a 1/0 test.
 */
#include "stdio.h"
#include "stdlib.h"

//return 0 is big_endian return 1 is small endian
int checkSystem()
{
        union check
        {
                int i;
                char ch;
        }c;
        c.i = 1;
        return (c.ch == 1);
}

int am_big_endian()
{
        long one= 1;
        return !(*((char *)(&one)));
}

int am_big_endian_union()
{
        union { long l; char c[sizeof (long)]; } u;
        u.l = 1;
        return (u.c[sizeof (long) - 1] == 1);
}

/* Main */
int main ( int argc,char *argv[] )
{
        int big = 0,big1 = 0, big2=0;
        big = checkSystem();
        if ( big )
        {
                printf("ret=%d\n",big);
                printf("return 0 is big_endian return 1 is small endian\n");
        }
        big1 = am_big_endian();
        if ( big1 )
        {
                printf("retbig1=%d\n",big1);
                printf("return 0 is big_endian return 1 is small endian\n");
        }
        big2 = am_big_endian_union();
        if ( big2 )
        {
                printf("retbig2=%d\n",big2);
                printf("return 0 is big_endian return 1 is small endian\n");
        }
        
        return 0;
}
