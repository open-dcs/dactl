include $(top_srcdir)/common.am

if ENABLE_WEBKIT

EXTRA_DIST = $(extensions_DATA)

extensionsdir = $(libdir)/dcs/extensions
extensions_LTLIBRARIES = libdcs-ui-extension-dom.la

BUILT_SOURCES = libdcs_ui_extension_dom_la_vala.stamp

libdcs_ui_extension_dom_la_vala.stamp: $(libdcs_ui_extension_dom_la_VALASOURCES)
	$(AM_V_GEN)$(VALAC) \
		$(libdcs_ui_extension_dom_la_VALAFLAGS) \
		$(addprefix $(srcdir)/,$(libdcs_ui_extension_dom_la_VALASOURCES)) \
		--ccode \
		&& touch $@

libdcs_ui_extension_dom_la_VALASOURCES = \
	dcs-ui-extension-dom.vala \
	$(NULL)

EXTRA_DIST += $(libdcs_ui_extension_dom_la_VALASOURCES)

nodist_libdcs_ui_extension_dom_la_SOURCES = \
	dcs-ui-extension-dom.c \
	$(NULL)

CLEANFILES = $(BUILT_SOURCES) $(nodist_libdcs_ui_extension_dom_la_SOURCES)

libdcs_ui_extension_dom_la_VALAFLAGS = \
	--vapidir=$(top_srcdir)/vapi \
	--pkg webkit2gtk-web-extension-4.0 \
	--pkg javascriptcoregtk-3.0 \
	$(NULL)

libdcs_ui_extension_dom_la_CFLAGS = \
	-DG_LOG_DOMAIN=\"libdcs-ui-extension-dom\" \
	-DGETTEXT_PACKAGE=\"dcs\" \
	$(WEBKIT_CFLAGS) \
	$(NULL)

libdcs_ui_extension_dom_la_LIBADD = $(WEBKIT_LIBS)
libdcs_ui_extension_dom_la_LDFLAGS = -module -avoid-version -no-undefined

endif

-include $(top_srcdir)/git.mk
