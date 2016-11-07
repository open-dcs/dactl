if ENABLE_VALA_PLUGIN

EXTRA_DIST = $(plugin_DATA)

plugindir = $(libdir)/dcs/plugins
plugin_LTLIBRARIES = libdcs-vala.la
dist_plugin_DATA = vala.plugin

BUILT_SOURCES = libdcs_vala_la_vala.stamp

libdcs_vala_la_vala.stamp: $(libdcs_vala_la_VALASOURCES)
	$(AM_V_GEN)$(VALAC) \
		$(libdcs_vala_la_VALAFLAGS) \
		$(addprefix $(srcdir)/,$(libdcs_vala_la_VALASOURCES)) \
		--ccode \
		&& touch $@

libdcs_vala_la_public_sources = \
	dcs-vala-plugin.c \
	$(NULL)

libdcs_vala_la_VALASOURCES = \
	dcs-vala-plugin.vala \
	$(NULL)

libdcs_vala_la_SOURCES = \
	$(libdcs_vala_la_VALASOURCES) \
	$(NULL)

CLEANFILES = $(BUILT_SOURCES)

libdcs_vala_la_VALAFLAGS = \
	$(PLUGIN_VALAFLAGS)

libdcs_vala_la_CFLAGS = \
	-DVALA_VERSION=\""$(VALA_VERSION)"\" \
	-DPACKAGE_DATADIR=\""$(datadir)/dcs-0.2"\" \
	-DG_LOG_DOMAIN=\"vala-plugin\" \
	-DGETTEXT_PACKAGE=\"dcs\" \
	$(PLUGIN_CFLAGS) \
	$(VALA_CFLAGS) \
	-Wno-deprecated-declarations \
	-Wno-discarded-qualifiers \
	-Wno-implicit-function-declaration \
	-Wno-incompatible-pointer-types \
	-Wno-unused-but-set-variable \
	-Wno-unused-label \
	-Wno-unused-function

libdcs_vala_la_LIBADD = $(VALA_LIBS)
libdcs_vala_la_LDFLAGS = $(PLUGIN_LDFLAGS)

if ENABLE_WEBKIT
libdcs_vala_la_VALAFLAGS += --pkg webkit2gtk-4.0
libdcs_vala_la_CFLAGS += $(WEBKIT_CFLAGS)
libdcs_vala_la_LIBADD += $(WEBKIT_LIBS)
libdcs_vala_la_LDFLAGS += $(WEBKIT_LDFLAGS)
endif

include $(top_srcdir)/src/plugins/Makefile.plugin

endif

-include $(top_srcdir)/git.mk
