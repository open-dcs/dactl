CLEANFILES =
DISTCLEANFILES =
BUILT_SOURCES =
EXTRA_DIST =

include $(top_srcdir)/common.am
include $(srcdir)/filelist.am

libdcsincdir = $(includedir)/dcs-0.2
libdcsinc_HEADERS = dcs-core.h

pkglibdir = $(libdir)/dcs
pkglib_LTLIBRARIES = libdcs-core-0.2.la

pkgconfig_DATA = dcs-core-0.2.pc
pkgconfigdir = $(libdir)/pkgconfig

LIBDCS_CORE_VERSION=0:2:0

libdcs_core_0_2_la_SOURCES = \
	$(LIBDCS_CORE_VAPI_SOURCE_FILES) \
	$(LIBDCS_CORE_NONVAPI_SOURCE_FILES) \
	$(NULL)

libdcs_core_0_2_la_includes = \
	$(DEBUG_CFLAGS) \
	-DPLUGIN_DIR=\""$(plugindir)"\" \
	-DSMALL_ICON_DIR=\""$(smallicondir)"\" \
	-DBIG_ICON_DIR=\""$(bigicondir)"\" \
	$(NULL)

libdcs_core_0_2_la_VALAFLAGS = \
	-H dcs-core.h -C \
	$(COVERAGE_VALAFLAGS) \
	--library=dcs-core-0.2 \
	--gir=Dcs-0.2.gir \
	--vapidir=$(top_srcdir)/vapi \
	--vapidir=$(top_srcdir)/src/libdcs-core \
	--pkg posix \
	--pkg linux \
	--pkg cld-0.3 \
	--pkg comedi \
	--pkg gee-0.8 \
	--pkg gio-2.0 \
	--pkg gmodule-2.0 \
	--pkg libxml-2.0 \
	--pkg libpeas-1.0 \
	--pkg dcs-build \
	$(DCS_CLD_DEPS_VALAFLAGS) \
	$(NULL)

libdcs_core_0_2_la_CFLAGS = \
	-DG_LOG_DOMAIN=\"libdcs-core\" \
	-DGETTEXT_PACKAGE=\"dcs\" \
	$(AM_CFLAGS) \
	$(LIBDCS_CFLAGS) \
	$(LIBDCS_CORE_CFLAGS) \
	$(DCS_CLD_DEPS_CFLAGS) \
	$(COVERAGE_CFLAGS) \
	$(OPTIMIZE_CFLAGS) \
	$(libdcs_core_0_2_la_includes) \
	-Wno-deprecated-declarations \
	-Wno-discarded-qualifiers \
	-Wno-implicit-function-declaration \
	-Wno-incompatible-pointer-types \
	-Wno-unused-but-set-variable \
	-Wno-unused-label \
	-Wno-unused-function \
	-Wformat-nonliteral \
	-Wredundant-decls \
	$(NULL)

libdcs_core_0_2_la_LDFLAGS = \
	$(OPTIMIZE_LDFLAGS) \
	$(DCS_DATA_DIR_DEFINES) \
	-version-info $(LIBDCS_CORE_VERSION) \
	$(NULL)

libdcs_core_0_2_la_LIBADD = \
	-lm \
	$(LIBDCS_LIBS) \
	$(LIBDCS_CORE_LIBS) \
	$(DCS_CLD_DEPS_LIBS) \
	$(COVERAGE_LIBS) \
	$(NULL)

if HAVE_INTROSPECTION
-include $(INTROSPECTION_MAKEFILE)

INTROSPECTION_GIRS =
INTROSPECTION_SCANNER_ARGS = --add-include-path=$(srcdir) --warn-all
INTROSPECTION_COMPILER_ARGS = -l libdcs-core-0.2.so.0
$(builddir)/DcsCore-0.2.gir: $(srcdir)/Dcs-0.2.gir
	$(AM_V_GEN)$(SED) -e 's,Dcs\.,DcsCore.,g' -e \
        's,namespace name="Dcs",namespace name="DcsCore",g' \
        $< >$@
GIRS = DcsCore-0.2.gir

girdir = $(datadir)/gir-1.0
gir_DATA = $(GIRS)

typelibdir = $(pkglibdir)/girepository-1.0
typelib_DATA = $(GIRS:.gir=.typelib)

CLEANFILES += $(gir_DATA) $(typelib_DATA)
endif


libdcs_core_0_2_vapi_DEPS = \
	posix \
	linux \
	cld-0.3 \
	comedi \
	gio-2.0 \
	gee-0.8 \
	libxml-2.0 \
	libpeas-1.0

dcs-core-0.2.deps: Makefile
	$(AM_V_GEN) echo $(libdcs_core_0_2_vapi_DEPS) | tr ' ' '\n' > $@

VAPI_FILES = dcs-core-0.2.vapi
DEPS_FILES = dcs-core-0.2.deps

vapidir = $(VAPIDIR)
vapi_DATA = $(VAPI_FILES) $(DEPS_FILES)
dcs-core.h dcs-core-0.2.vapi Dcs-0.2.gir: libdcs_core_0_2_la_vala.stamp

BUILT_SOURCES += \
	dcs-core.h \
	dcs-build.vapi \
	$(VAPI_FILES) \
	$(DEPS_FILES) \
	DcsCore-0.2.gir \
	Dcs-0.2.gir \
	$(NULL)

EXTRA_DIST += \
	$(BUILT_SOURCES) \
	$(NULL)

-include $(top_srcdir)/git.mk
