SUBDIRS = xml man md uml

if ENABLE_DOC

include Makefile.sphinx

docdir=$(datadir)/devhelp/references/dcs-0.1
innerdocdir=$(datadir)/devhelp/references/dcs-0.1/dcs-0.1
imgdir=$(datadir)/devhelp/references/dcs-0.1/dcs-0.1/img

core_valaflags = \
	--pkg=cld-0.3 \
	--pkg=comedi \
	--pkg=dcs-config \
	--pkg=gee-0.8 \
	--pkg=gmodule-2.0 \
	--pkg=json-glib-1.0 \
	--pkg=libxml-2.0 \
	--pkg=libpeas-1.0

ui_valaflags = \
	--pkg=cairo \
	--pkg=gsl \
	--pkg=gtk+-3.0 \
	--pkg=gtksourceview-3.0 \
	--pkg=librsvg-2.0 \
	--pkg=pango \
	--pkg=webkit2gtk-4.0

net_valaflags = \
	--pkg=libsoup-2.4 \
	--pkg=libzmq

doc_data = \
	dcs-0.1/*.css \
	dcs-0.1/*.png \
	$(NULL)

doc_DATA = \
	dcs-0.1/index.html \
	$(doc_data) \
	$(NULL)

innerdoc_DATA = \
	dcs-0.1/dcs-0.1/index.htm \
	dcs-0.1/dcs-0.1/*.html \
	$(NULL)

img_DATA = \
	dcs-0.1/dcs-0.1/*.png \
	$(NULL)

$(doc_data) $(innerdoc_DATA) $(img_DATA): dcs-0.1/index.html

dcs-0.1/index.html:
	$(VALADOC) -o dcs-0.1/ --wiki ./ --target-glib=2.44 \
		--force -b $(top_srcdir) \
		$(top_srcdir)/src/libdcs-core/*.vala \
		$(top_srcdir)/src/libdcs-ui/*.vala \
		$(top_srcdir)/src/libdcs-cli/*.vala \
		$(top_srcdir)/src/libdcs-daq/*.vala \
		$(top_srcdir)/src/libdcs-log/*.vala \
		$(top_srcdir)/src/libdcs-net/*.vala \
		--pkg=linux \
		--pkg=posix \
		$(core_valaflags) \
		$(ui_valaflags) \
		$(net_valaflags) \
		--vapidir=$(top_srcdir)/src/libdcs-core \
		--vapidir=$(top_srcdir)/vapi

EXTRA_DIST = \
	index.wiki \
	$(NULL)

endif

GITIGNOREFILES = \
	build \
	dcs-0.1 \
	html \
	$(NULL)

-include $(top_srcdir)/git.mk
