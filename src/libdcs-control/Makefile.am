CLEANFILES =
DISTCLEANFILES =
BUILT_SOURCES =
EXTRA_DIST =

include $(top_srcdir)/common.am

pkglibdir = $(libdir)/dcs
pkglib_LTLIBRARIES = libdcs-control-0.1.la

headersdir = $(includedir)/dcs-@VERSION@/libdcs-control
nobase_headers_DATA =

pkgconfig_DATA = dcs-control-0.1.pc
pkgconfigdir = $(libdir)/pkgconfig

EXTRA_DIST += \
	dcs-control-0.1.pc.in \
	$(NULL)

LIBDCS_CONTROL_VERSION=0:1:0

libdcs_control_0_1_la_public_headers = \
	$(NULL)

libdcs_control_0_1_la_public_sources = \
	dcs-control-loop.c \
	dcs-control-loop-manager.c \
	dcs-control-factory.c \
	$(NULL)

libdcs_control_0_1_la_VALASOURCES = \
	dcs-control-loop.vala \
	dcs-control-loop-manager.vala \
	dcs-control-factory.vala \
	$(NULL)

libdcs_control_0_1_la_SOURCES = \
	$(libdcs_control_0_1_la_VALASOURCES) \
	$(NULL)

libdcs_control_0_1_la_includes = \
	$(DEBUG_CFLAGS) \
	-DPACKAGE_DATADIR="\"${datadir}\"" \
	-DPACKAGE_LOCALE_DIR=\""${datadir}/locale"\" \
	-DPACKAGE_LIBDIR=\""${libdir}"\" \
	-DBUILDDIR=\""${abs_top_builddir}"\" \
	-DSRCDIR=\""${abs_top_srcdir}"\" \
	-I$(top_srcdir)/src/libdcs-core \
	-I$(top_srcdir)/src/libdcs-net \
	$(NULL)

libdcs_control_0_1_la_VALAFLAGS = \
	-H dcs-control.h -C \
	--library=dcs-control-0.1 \
	--gir=Dcs-0.1.gir \
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
	--pkg dcs-core-0.1 \
	--pkg dcs-net-0.1 \
	--pkg dcs-config \
	$(NULL)

libdcs_control_0_1_la_CFLAGS = \
	-DG_LOG_DOMAIN=\"libdcs-control\" \
	-DGETTEXT_PACKAGE=\"dcs\" \
	-DLOOP_DIR=\""$(loopdir)"\" \
	$(AM_CFLAGS) \
	$(LIBDCS_CFLAGS) \
	$(LIBDCS_CONTROL_CFLAGS) \
	$(LIBDCS_NET_CFLAGS) \
	$(OPTIMIZE_CFLAGS) \
	$(DEBUG_CFLAGS) \
	$(libdcs_control_0_1_la_includes) \
	-Wno-deprecated-declarations \
	-Wno-discarded-qualifiers \
	-Wno-implicit-function-declaration \
	-Wno-incompatible-pointer-types \
	-Wno-unused-but-set-variable \
	-Wno-unused-label \
	-Wno-unused-function \
	$(NULL)

libdcs_control_0_1_la_LDFLAGS = \
	$(OPTIMIZE_LDFLAGS) \
	-version-info $(LIBDCS_CONTROL_VERSION) \
	$(NULL)

libdcs_control_0_1_la_LIBADD = \
	$(LIBDCS_LIBS) \
	$(LIBDCS_CONTROL_LIBS) \
	$(LIBDCS_NET_LIBS) \
	$(NULL)


if HAVE_INTROSPECTION
-include $(INTROSPECTION_MAKEFILE)

INTROSPECTION_GIRS =
INTROSPECTION_SCANNER_ARGS = --add-include-path=$(srcdir) --warn-all
INTROSPECTION_COMPILER_ARGS = \
	-l libdcs-control-0.1.so.0 \
	--includedir=$(builddir)/../libdcs-core \
	--includedir=$(srcdir)/../libdcs-core
$(builddir)/DcsControl-0.1.gir: $(srcdir)/Dcs-0.1.gir
	$(AM_V_GEN)$(SED) \
		-e 's,Dcs\.,DcsControl.,g' \
		-e 's,namespace name="Dcs",namespace name="DcsControl",g' \
		-e 's,DcsControl\.Extension,DcsCore.Extension,g' \
		-e 's,<package name="dcs-control-0.1"/>,<include name="DcsCore" version="0.1"/>\n<package name="dcs-control-0.1"/>,' \
		$< >$@
GIRS = DcsControl-0.1.gir

girdir = $(datadir)/dcs/gir-1.0
gir_DATA = $(GIRS)

typelibdir = $(pkglibdir)/girepository-1.0
typelib_DATA = $(GIRS:.gir=.typelib)

CLEANFILES += $(gir_DATA) $(typelib_DATA)
endif


libdcs_control_0_1_vapi_DEPS = \
	posix \
	gee-0.8 \
	gio-2.0 \
	json-glib-1.0

dcs-control-0.1.deps: Makefile
	$(AM_V_GEN) echo $(libdcs_control_0_1_vapi_DEPS) | tr ' ' '\n' > $@

VAPI_FILES = dcs-control-0.1.vapi
DEPS_FILES = dcs-control-0.1.deps

vapidir = $(VAPIDIR)
vapi_DATA = $(VAPI_FILES) $(DEPS_FILES)
dcs-control.h dcs-control-0.1.vapi Dcs-0.1.gir: libdcs_control_0_1_la_vala.stamp

BUILT_SOURCES += \
	dcs-control.h \
	$(VAPI_FILES) \
	$(DEPS_FILES) \
	DcsControl-0.1.gir \
	Dcs-0.1.gir \
	$(NULL)

-include $(top_srcdir)/git.mk
