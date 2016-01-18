#
# w3mimg/x11/Makefile
#
#

SHELL=/bin/sh
srcdir = .
top_srcdir = ../..
VPATH = .
RM=rm

IMGCFLAGS=
OBJS=x11_w3mimg.o

all: x11_w3mimg.o

x11_w3mimg.o: x11_w3mimg.c
	$(CC) $(CFLAGS) $(IMGCFLAGS) -I../.. -I$(top_srcdir) -I$(srcdir) -c $<

clean:
	@-$(RM) -f *.o

distclean: clean
	-$(RM) -f Makefile

#


