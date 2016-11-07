XSLTPROC = xsltproc

EXTRA_DIST = \
	$(HTMLS:../html/%.html=%.xml) \
	authors.xml \
	notes.xml \
	seealso.xml \
	dcs-subcommands.xml \
	dcs-utility-common-options.xml \
	dcs-utility-common-synopsis.xml \
	transform-man.xsl.in \
	transform-html.xsl.in \
	$(NULL)

man_MANS = \
	$(man1_MANS) \
	$(NULL)

HTMLS = \
	$(man1_MANS:../man/man1/%.1=../html/%.html) \
	$(NULL)

man1_MANS = \
	../man/man1/dcs.1 \
	../man/man1/dcs-publish.1 \
	../man/man1/dcs-subscribe.1 \
	../man/man1/dcs-request.1 \
	../man/man1/dcs-reply.1 \
	../man/man1/dcs-daqd.1 \
	../man/man1/dcs-logd.1 \
	../man/man1/dcs-controld.1 \
	../man/man1/dcsg.1 \
	$(NULL)

DISTCLEANFILES = $(man_MANS) $(HTMLS) transform-*.xsl


XSLTPROC_FLAGS = --nonet --xinclude
XSLTPROC_MAN_FLAGS = $(XSLTPROC_FLAGS) transform-man.xsl
XSLTPROC_HTML_FLAGS = $(XSLTPROC_FLAGS) transform-html.xsl

install:

all: $(man_MANS) $(HTMLS) $(MARKDOWNS)

clean:
	-test -z "$(CLEAN_FILES)" || rm -f $(CLEAN_FILES)

../man/man1/%.1: %.xml authors.xml notes.xml seealso.xml transform-man.xsl
	$(XSLTPROC) -o $@ $(XSLTPROC_MAN_FLAGS) $<

../html/%.html: %.xml authors.xml notes.xml seealso.xml transform-html.xsl
	$(XSLTPROC) -o $@ $(XSLTPROC_HTML_FLAGS) $<

edit = sed \
	-e 's|\@PREFIX\@|$(prefix)|' \
	-e 's|\@SYSCONFDIR\@|$(sysconfdir)|' \
	-e 's|\@PACKAGE_STRING\@|$(PACKAGE_STRING)|'

transform-man.xsl: transform-man.xsl.in
	$(edit) $< >$@

transform-html.xsl: transform-html.xsl.in
	$(edit) $< >$@

-include $(top_srcdir)/git.mk
