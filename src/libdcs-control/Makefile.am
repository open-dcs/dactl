include $(top_srcdir)/common.am

CLEANFILES =
DISTCLEANFILES =
BUILT_SOURCES =
EXTRA_DIST =

libdcscontrolincdir = $(includedir)/dcs-0.2
libdcscontrolinc_HEADERS = dcs-control.h

pkglibdir = $(libdir)/dcs
pkglib_LTLIBRARIES = libdcs-control-0.2.la

headersdir = $(includedir)/dcs-@VERSION@/libdcs-control
nobase_headers_DATA =

pkgconfig_DATA = dcs-control-0.2.pc
pkgconfigdir = $(libdir)/pkgconfig

LIBDCS_CONTROL_VERSION=0:2:0

libdcs_control_0_2_la_public_headers = \
	$(NULL)

libdcs_control_0_2_la_public_sources = \
	dcs-control-controller.c \
	dcs-control-loop-manager.c \
	dcs-control-factory.c \
	$(NULL)

libdcs_control_0_2_la_VALASOURCES = \
	dcs-control-controller.vala \
	dcs-control-loop-manager.vala \
	dcs-control-factory.vala \
	$(NULL)

libdcs_control_0_2_la_SOURCES = \
	$(libdcs_control_0_2_la_VALASOURCES) \
	$(NULL)

libdcs_control_0_2_la_includes = \
	$(DEBUG_CFLAGS) \
	-DPACKAGE_DATADIR="\"${datadir}\"" \
	-DPACKAGE_LOCALE_DIR=\""${datadir}/locale"\" \
	-DPACKAGE_LIBDIR=\""${libdir}"\" \
	-DBUILDDIR=\""${abs_top_builddir}"\" \
	-DSRCDIR=\""${abs_top_srcdir}"\" \
	-I$(top_srcdir)/src/libdcs-core \
	-I$(top_srcdir)/src/libdcs-net \
	$(NULL)

libdcs_control_0_2_la_VALAFLAGS = \
	-H dcs-control.h -C \
	--library=dcs-control-0.2 \
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
	$(COVERAGE_VALAFLAGS) \
	$(NULL)

libdcs_control_0_2_la_CFLAGS = \
	-DG_LOG_DOMAIN=\"libdcs-control\" \
	-DGETTEXT_PACKAGE=\"dcs\" \
	-DCONTROLLER_DIR=\""$(controllerdir)"\" \
	$(AM_CFLAGS) \
	$(LIBDCS_CFLAGS) \
	$(LIBDCS_CONTROL_CFLAGS) \
	$(LIBDCS_NET_CFLAGS) \
	$(OPTIMIZE_CFLAGS) \
	$(COVERAGE_CFLAGS) \
	$(DEBUG_CFLAGS) \
	$(libdcs_control_0_2_la_includes) \
	-Wno-deprecated-declarations \
	-Wno-discarded-qualifiers \
	-Wno-implicit-function-declaration \
	-Wno-incompatible-pointer-types \
	-Wno-unused-but-set-variable \
	-Wno-unused-label \
	-Wno-unused-function \
	$(NULL)

libdcs_control_0_2_la_LDFLAGS = \
	$(OPTIMIZE_LDFLAGS) \
	-version-info $(LIBDCS_CONTROL_VERSION) \
	$(NULL)

libdcs_control_0_2_la_LIBADD = \
	$(LIBDCS_LIBS) \
	$(LIBDCS_CONTROL_LIBS) \
	$(LIBDCS_NET_LIBS) \
	$(COVERAGE_LIBS) \
	$(NULL)


if HAVE_INTROSPECTION
-include $(INTROSPECTION_MAKEFILE)

INTROSPECTION_GIRS =
INTROSPECTION_SCANNER_ARGS = --add-include-path=$(srcdir) --warn-all
INTROSPECTION_COMPILER_ARGS = \
	-l libdcs-control-0.2.so.0 \
	--includedir=$(builddir)/../libdcs-core \
	--includedir=$(srcdir)/../libdcs-core
$(builddir)/DcsControl-0.2.gir: $(srcdir)/Dcs-0.2.gir
	$(AM_V_GEN)$(SED) \
		-e 's,Dcs\.,DcsControl.,g' \
		-e 's,namespace name="Dcs",namespace name="DcsControl",g' \
		-e 's,DcsControl\.Extension,DcsCore.Extension,g' \
		-e 's,DcsControl\.Node,DcsCore.Node,g' \
		-e 's,<package name="dcs-control-0.2"/>,<include name="DcsCore" version="0.2"/>\n<package name="dcs-control-0.2"/>,' \
		$< >$@
GIRS = DcsControl-0.2.gir

girdir = $(datadir)/dcs/gir-1.0
gir_DATA = $(GIRS)

typelibdir = $(pkglibdir)/girepository-1.0
typelib_DATA = $(GIRS:.gir=.typelib)

CLEANFILES += $(gir_DATA) $(typelib_DATA)
endif


libdcs_control_0_2_vapi_DEPS = \
	posix \
	gee-0.8 \
	gio-2.0 \
	json-glib-1.0

dcs-control-0.2.deps: Makefile
	$(AM_V_GEN) echo $(libdcs_control_0_2_vapi_DEPS) | tr ' ' '\n' > $@

VAPI_FILES = dcs-control-0.2.vapi
DEPS_FILES = dcs-control-0.2.deps

vapidir = $(VAPIDIR)
vapi_DATA = $(VAPI_FILES) $(DEPS_FILES)
dcs-control.h dcs-control-0.2.vapi Dcs-0.2.gir: libdcs_control_0_2_la_vala.stamp

BUILT_SOURCES += \
	dcs-control.h \
	$(VAPI_FILES) \
	$(DEPS_FILES) \
	DcsControl-0.2.gir \
	Dcs-0.2.gir \
	$(NULL)

EXTRA_DIST += \
	$(BUILT_SOURCES) \
	$(NULL)

-include $(top_srcdir)/git.mk
