CLEANFILES =
DISTCLEANFILES =
BUILT_SOURCES =
EXTRA_DIST =

include $(top_srcdir)/common.am

pkglibdir = $(libdir)/dcs
pkglib_LTLIBRARIES = libdcs-log-0.2.la

headersdir = $(includedir)/dcs-@VERSION@/libdcs-log
nobase_headers_DATA =

pkgconfig_DATA = dcs-log-0.2.pc
pkgconfigdir = $(libdir)/pkgconfig

LIBDCS_LOG_VERSION=0:2:0

libdcs_log_0_2_la_public_headers = \
	$(NULL)

libdcs_log_0_2_la_public_sources = \
	dcs-log-backend.c \
	dcs-log-backend-manager.c \
	dcs-log-factory.c \
	$(NULL)

libdcs_log_0_2_la_VALASOURCES = \
	dcs-log-backend.vala \
	dcs-log-backend-manager.vala \
	dcs-log-factory.vala \
	$(NULL)

libdcs_log_0_2_la_SOURCES = \
	$(libdcs_log_0_2_la_VALASOURCES) \
	$(NULL)

libdcs_log_0_2_la_includes = \
	$(DEBUG_CFLAGS) \
	-DPACKAGE_DATADIR="\"${datadir}\"" \
	-DPACKAGE_LOCALE_DIR=\""${datadir}/locale"\" \
	-DPACKAGE_LIBDIR=\""${libdir}"\" \
	-DBUILDDIR=\""${abs_top_builddir}"\" \
	-DSRCDIR=\""${abs_top_srcdir}"\" \
	-I$(top_srcdir)/src/libdcs-core \
	-I$(top_srcdir)/src/libdcs-net \
	$(NULL)

libdcs_log_0_2_la_VALAFLAGS = \
	-H dcs-log.h -C \
	--library=dcs-log-0.2 \
	--gir=Dcs-0.2.gir \
	--vapidir=$(top_srcdir)/vapi \
	--vapidir=$(top_srcdir)/src/libdcs-core \
	--vapidir=$(top_srcdir)/src/libdcs-net \
	--pkg posix \
	--pkg gio-2.0 \
	--pkg gee-0.8 \
	--pkg json-glib-1.0 \
	--pkg libpeas-1.0 \
	--pkg libsoup-2.4 \
	--pkg libzmq \
	--pkg dcs-core-0.2 \
	--pkg dcs-net-0.2 \
	--pkg dcs-build \
	$(NULL)

libdcs_log_0_2_la_CFLAGS = \
	-DG_LOG_DOMAIN=\"libdcs-log\" \
	-DGETTEXT_PACKAGE=\"dcs\" \
	-DBACKEND_DIR=\""$(backenddir)"\" \
	$(AM_CFLAGS) \
	$(LIBDCS_CFLAGS) \
	$(LIBDCS_LOG_CFLAGS) \
	$(LIBDCS_NET_CFLAGS) \
	$(OPTIMIZE_CFLAGS) \
	$(DEBUG_CFLAGS) \
	$(libdcs_log_0_2_la_includes) \
	-Wno-deprecated-declarations \
	-Wno-discarded-qualifiers \
	-Wno-implicit-function-declaration \
	-Wno-incompatible-pointer-types \
	-Wno-unused-but-set-variable \
	-Wno-unused-label \
	-Wno-unused-function \
	$(NULL)

libdcs_log_0_2_la_LDFLAGS = \
	$(OPTIMIZE_LDFLAGS) \
	-version-info $(LIBDCS_LOG_VERSION) \
	$(NULL)

libdcs_log_0_2_la_LIBADD = \
	$(LIBDCS_LIBS) \
	$(LIBDCS_LOG_LIBS) \
	$(LIBDCS_NET_LIBS) \
	$(NULL)


if HAVE_INTROSPECTION
-include $(INTROSPECTION_MAKEFILE)

INTROSPECTION_GIRS =
INTROSPECTION_SCANNER_ARGS = --add-include-path=$(srcdir) --warn-all
INTROSPECTION_COMPILER_ARGS = \
	-l libdcs-log-0.2.so.0 \
	--includedir=$(builddir)/../libdcs-core \
	--includedir=$(srcdir)/../libdcs-core
$(builddir)/DcsLog-0.2.gir: $(srcdir)/Dcs-0.2.gir
	$(AM_V_GEN)$(SED) \
		-e 's,Dcs\.,DcsLog.,g' \
		-e 's,namespace name="Dcs",namespace name="DcsLog",g' \
		-e 's,DcsLog\.Extension,DcsCore.Extension,g' \
		-e 's,<package name="dcs-log-0.2"/>,<include name="DcsCore" version="0.2"/>\n<package name="dcs-log-0.2"/>,' \
		$< >$@
GIRS = DcsLog-0.2.gir

girdir = $(datadir)/dcs/gir-1.0
gir_DATA = $(GIRS)

typelibdir = $(pkglibdir)/girepository-1.0
typelib_DATA = $(GIRS:.gir=.typelib)

CLEANFILES += $(gir_DATA) $(typelib_DATA)
endif


libdcs_log_0_2_vapi_DEPS = \
	posix \
	gee-0.8 \
	gio-2.0 \
	json-glib-1.0

dcs-log-0.2.deps: Makefile
	$(AM_V_GEN) echo $(libdcs_log_0_2_vapi_DEPS) | tr ' ' '\n' > $@

VAPI_FILES = dcs-log-0.2.vapi
DEPS_FILES = dcs-log-0.2.deps

vapidir = $(VAPIDIR)
vapi_DATA = $(VAPI_FILES) $(DEPS_FILES)
dcs-log.h dcs-log-0.2.vapi Dcs-0.2.gir: libdcs_log_0_2_la_vala.stamp

BUILT_SOURCES += \
	dcs-log.h \
	$(VAPI_FILES) \
	$(DEPS_FILES) \
	DcsLog-0.2.gir \
	Dcs-0.2.gir \
	$(NULL)

EXTRA_DIST += \
	$(BUILT_SOURCES) \
	$(NULL)

-include $(top_srcdir)/git.mk
