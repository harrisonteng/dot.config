#
# w3mimg/Makefile
#

SHELL=/bin/sh
srcdir = .
top_srcdir = ..
VPATH = .
AR=ar
RANLIB=ranlib
RM=rm

IMGCFLAGS= 
IMGOBJS=w3mimg.o

.PHONY: fb x11
all:  w3mimg.a

w3mimg.a: $(IMGOBJS)
	$(AR) rv $@ $(IMGOBJS)
	$(RANLIB) $@

w3mimg.o: w3mimg.c
	$(CC) $(CFLAGS) $(IMGCFLAGS) -I.. -I$(top_srcdir) -I$(srcdir) -c $<

fb x11:
	cd $@ && $(MAKE) CC="$(CC)" CFLAGS="$(CFLAGS)"

clean:
	@-$(RM) -f *.o
	@for dir in fb x11; do \
		(cd $$dir && $(MAKE) clean RM=$(RM)); \
	 done

distclean: clean
	for subdir in fb x11; \
	do \
		(cd $$subdir && $(MAKE) distclean); \
	done
	-$(RM) -f w3mimg.a
	-$(RM) -f Makefile


#
