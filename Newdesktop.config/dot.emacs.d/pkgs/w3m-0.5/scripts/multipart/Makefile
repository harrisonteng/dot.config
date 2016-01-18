
SHELL=/bin/sh
PACKAGE = w3m
VERSION = 0.4.2
DOMAIN = $(PACKAGE)
srcidr=.
top_srcdir=../..
VPATH= .
prefix = /usr/local
exec_prefix = ${prefix}
bindir = ${exec_prefix}/bin
datadir = ${prefix}/share
libdir = ${exec_prefix}/lib
includedir = ${prefix}/include
infodir = ${prefix}/info
libexecdir = ${exec_prefix}/libexec
localstatedir = ${prefix}/var
mandir = ${prefix}/man
oldincludedir = /usr/include
sbindir = ${exec_prefix}/sbin
sharedstatedir = ${prefix}/com
srcdir = .
sysconfdir = ${prefix}/etc
top_srcdir = ../..
VPATH = $(top_srcdir):.
DESTDIR = 

CGIBIN_DIR = $(libexecdir)/$(PACKAGE)/cgi-bin
AUXBIN_DIR = $(libexecdir)/$(PACKAGE)
HELP_DIR = ${prefix}/share/w3m
RC_DIR = ~/.w3m
ETC_DIR = $(sysconfdir)
CONF_DIR = $(sysconfdir)/$(PACKAGE)

LIB_TARGETS	= multipart.cgi

MKDIR		= mkdir -p
INSTALL		= /usr/bin/install -c
INSTALL_SCRIPT	= ${INSTALL}

PERL		= /usr/bin/perl
NKF		= /usr/local/bin/nkf

all: $(LIB_TARGETS)

# do nothing
$(LIB_TARGETS):

install: $(LIB_TARGETS)
	-$(MKDIR) $(DESTDIR)$(LIB_DIR)
	for file in $(LIB_TARGETS);	\
	do	\
		$(INSTALL_SCRIPT) $$file $(DESTDIR)$(LIB_DIR);	\
	done

uninstall:
	-for file in $(LIB_TARGETS);	\
	do	\
		rm -f $(LIB_DIR)/$$file;	\
	done

clean:

distclean:
	-rm -f $(LIB_TARGETS)
	-rm -f Makefile

dist: all
	@-rm -fr $(distdir)/multipart
	$(MKDIR) $(distdir)/multipart
	cp Makefile README multipart.cgi.in $(distdir)/multipart
	( cd $(distdir); tar -cf - multipart | GZIP='' gzip ) \
		> $(distdir)/multipart.tar.gz
	-rm -fr $(distdir)/multipart

