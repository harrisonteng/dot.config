#
# w3mimg/fb/Makefile
#
#

SHELL=/bin/sh
srcdir = .
top_srcdir = ../..
VPATH = .
RM=rm

IMGCFLAGS=
OBJS=fb.o fb_img.o 

all: fb_w3mimg.o fb.o fb_img.o

fb_w3mimg.o: fb_w3mimg.c
	$(CC) $(CFLAGS) $(IMGCFLAGS) -I../.. -I$(top_srcdir) -I$(srcdir) -c $<

fb.o: fb.c
	$(CC) $(CFLAGS) $(IMGCFLAGS) -I../.. -I$(top_srcdir) -I$(srcdir) -c $<

fb_img.o: fb_img.c fb_gdkpixbuf.c fb_imlib2.c
	$(CC) $(CFLAGS) $(IMGCFLAGS) -I../.. -I$(top_srcdir) -I$(srcdir) -c $<

clean:
	@-$(RM) -f *.o

distclean: clean
	-$(RM) -f Makefile

#


