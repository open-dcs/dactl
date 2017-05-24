if ENABLE_XML_BACKEND

EXTRA_DIST = $(plugin_DATA)

plugindir = $(libdir)/dcs/backends
plugin_LTLIBRARIES = libdcs-backend-xml.la
dist_plugin_DATA = xml.plugin

BUILT_SOURCES = libdcs_backend_xml_la_vala.stamp

libdcs_backend_xml_la_vala.stamp: $(libdcs_backend_xml_la_VALASOURCES)
	$(AM_V_GEN)$(VALAC) \
		$(libdcs_backend_xml_la_VALAFLAGS) \
		$(addprefix $(srcdir)/,$(libdcs_backend_xml_la_VALASOURCES)) \
		--ccode \
		&& touch $@

libdcs_backend_xml_la_public_sources = \
	xml-backend.c \
	dcs-xml-service-addin.c \
	$(NULL)

libdcs_backend_xml_la_VALASOURCES = \
	xml-backend.vala \
	dcs-xml-service-addin.vala \
	$(NULL)

libdcs_backend_xml_la_SOURCES = \
	$(libdcs_backend_xml_la_VALASOURCES) \
	$(NULL)

CLEANFILES = $(BUILT_SOURCES)

libdcs_backend_xml_la_VALAFLAGS = \
	$(BACKEND_VALAFLAGS) \
	$(NULL)

libdcs_backend_xml_la_CFLAGS = \
	-DVALA_VERSION=\""$(VALA_VERSION)"\" \
	-DPACKAGE_DATADIR=\""$(datadir)/dcs-0.2"\" \
	-DG_LOG_DOMAIN=\"xml-backend\" \
	-DGETTEXT_PACKAGE=\"dcs\" \
	$(BACKEND_CFLAGS) \
	$(LIBDCS_LOG_CFLAGS) \
	-Wno-deprecated-declarations \
	-Wno-discarded-qualifiers \
	-Wno-implicit-function-declaration \
	-Wno-incompatible-pointer-types \
	-Wno-unused-but-set-variable \
	-Wno-unused-label \
	-Wno-unused-function \
	$(NULL)

libdcs_backend_xml_la_LIBADD = $(BACKEND_LIBS)

libdcs_backend_xml_la_LDFLAGS = \
	$(BACKEND_LDFLAGS) \
	$(LIBDCS_LOG_LDFLAGS) \
	$(NULL)

include $(top_srcdir)/src/backends/Makefile.backend

endif

-include $(top_srcdir)/git.mk
