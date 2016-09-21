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

MARKDOWNS = \
	$(man1_MANS:../man/man1/%.1=../md/%.md) \
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

../md/%.md: $(HTMLS)
	$(md) $< >$@

edit = sed \
	-e 's|\@PREFIX\@|$(prefix)|' \
	-e 's|\@SYSCONFDIR\@|$(sysconfdir)|' \
	-e 's|\@PACKAGE_STRING\@|$(PACKAGE_STRING)|'

# This is disgusting, buuut less work than writing an XSLT
md = sed \
	-e 's|^\s*||' \
	-e 's|><|>\n<|g' \
	-e 's|<[/]\?html[^>]*>||g' \
	-e 's|<[/]\?head[^>]*>||g' \
	-e 's|<[/]\?meta[^>]*>||g' \
	-e 's|<[/]\?title[^>]*>||g' \
	-e 's|<[/]\?body[^>]*>||g' \
	-e 's|<[/]\?div[^>]*>||g' \
	-e 's|<[/]\?d[dt][^>]*>||g' \
	-e 's|<[/]\?blockquote[^>]*>||g' \
	-e 's|<h1>\([[:space:][:alnum:]]\+\)<\/h1>|\n\# \1\n|' \
	-e 's|<h2>\([[:space:][:alnum:]]\+\)<\/h2>|\n\#\# \1\n|' \
	-e 's|<h3>\([[:space:][:alnum:]]\+\)<\/h3>|\n\#\#\# \1\n|' \
	-e 's|<h4>\([[:space:][:alnum:]]\+\)<\/h4>|\n\#\#\#\# \1\n|' \
	-e 's|<h5>\([[:space:][:alnum:]]\+\)<\/h5>|\n\#\#\#\#\# \1\n|' \
	-e 's|<h6>\([[:space:][:alnum:]]\+\)<\/h6>|\n\#\#\#\#\#\# \1\n|'

transform-man.xsl: transform-man.xsl.in
	$(edit) $< >$@

transform-html.xsl: transform-html.xsl.in
	$(edit) $< >$@

-include $(top_srcdir)/git.mk
