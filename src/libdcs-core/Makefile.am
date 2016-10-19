CLEANFILES =
DISTCLEANFILES =
BUILT_SOURCES =
EXTRA_DIST =

include $(top_srcdir)/common.am
include $(srcdir)/filelist.am

libdcsincdir = $(includedir)/dcs-0.1

libdcsinc_HEADERS = dcs-core.h

lib_LTLIBRARIES = libdcs-core-0.1.la

pkgconfig_DATA = dcs-core-0.1.pc
pkgconfigdir = $(libdir)/pkgconfig

EXTRA_DIST += \
	dcs-core-0.1.pc.in \
	$(NULL)

LIBDCS_CORE_VERSION=0:1:0

libdcs_core_0_1_la_SOURCES = \
	$(LIBDCS_CORE_VAPI_SOURCE_FILES) \
	$(LIBDCS_CORE_NONVAPI_SOURCE_FILES) \
	$(NULL)

libdcs_core_0_1_la_includes = \
	$(DEBUG_CFLAGS) \
	-DPLUGIN_DIR=\""$(plugindir)"\" \
	-DSMALL_ICON_DIR=\""$(smallicondir)"\" \
	-DBIG_ICON_DIR=\""$(bigicondir)"\" \
	$(NULL)

libdcs_core_0_1_la_VALAFLAGS = \
	-H dcs-core.h -C \
	--library=dcs-core-0.1 \
	--gir=Dcs-0.1.gir \
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
	--pkg dcs-config \
	--pkg dcs-core-0.1 \
	$(DCS_CLD_DEPS_VALAFLAGS) \
	$(NULL)

libdcs_core_0_1_la_CFLAGS = \
	-DG_LOG_DOMAIN=\"libdcs-core\" \
	-DGETTEXT_PACKAGE=\"dcs\" \
	$(AM_CFLAGS) \
	$(LIBDCS_CFLAGS) \
	$(LIBDCS_CORE_CFLAGS) \
	$(DCS_CLD_DEPS_CFLAGS) \
	$(OPTIMIZE_CFLAGS) \
	$(libdcs_core_0_1_la_includes) \
	-Wno-deprecated-declarations \
	-Wno-discarded-qualifiers \
	-Wno-implicit-function-declaration \
	-Wno-incompatible-pointer-types \
	-Wno-unused-but-set-variable \
	-Wno-unused-label \
	-Wno-unused-function \
	-Wformat-nonliteral \
	$(NULL)

libdcs_core_0_1_la_LDFLAGS = \
	$(OPTIMIZE_LDFLAGS) \
	$(DCS_DATA_DIR_DEFINES) \
	-version-info $(LIBDCS_CORE_VERSION) \
	$(NULL)

libdcs_core_0_1_la_LIBADD = \
	-lm \
	$(LIBDCS_LIBS) \
	$(LIBDCS_CORE_LIBS) \
	$(DCS_CLD_DEPS_LIBS) \
	$(NULL)

if HAVE_INTROSPECTION
-include $(INTROSPECTION_MAKEFILE)

INTROSPECTION_GIRS =
INTROSPECTION_SCANNER_ARGS = --add-include-path=$(srcdir) --warn-all
INTROSPECTION_COMPILER_ARGS = -l libdcs-core-0.1.so.0
$(builddir)/DcsCore-0.1.gir: $(srcdir)/Dcs-0.1.gir
	$(AM_V_GEN)$(SED) -e 's,Dcs\.,DcsCore.,g' -e \
        's,namespace name="Dcs",namespace name="DcsCore",g' \
        $< >$@
GIRS = DcsCore-0.1.gir

girdir = $(datadir)/gir-1.0
gir_DATA = $(GIRS)

typelibdir = $(libdir)/girepository-1.0
typelib_DATA = $(GIRS:.gir=.typelib)

CLEANFILES += $(gir_DATA) $(typelib_DATA)
endif


libdcs_core_0_1_vapi_DEPS = \
	posix \
	linux \
	cld-0.3 \
	comedi \
	gio-2.0 \
	gee-0.8 \
	libxml-2.0 \
	libpeas-1.0

dcs-core-0.1.deps: Makefile
	$(AM_V_GEN) echo $(libdcs_core_0_1_vapi_DEPS) | tr ' ' '\n' > $@

VAPI_FILES = dcs-core-0.1.vapi
DEPS_FILES = dcs-core-0.1.deps

vapidir = $(VAPIDIR)
vapi_DATA = $(VAPI_FILES) $(DEPS_FILES)
dcs-core.h dcs-core-0.1.vapi Dcs-0.1.gir: libdcs_core_0_1_la_vala.stamp

BUILT_SOURCES += \
	dcs-core.h \
	$(VAPI_FILES) \
	$(DEPS_FILES) \
	dcs-config.vapi \
	DcsCore-0.1.gir \
	Dcs-0.1.gir \
	$(NULL)

-include $(top_srcdir)/git.mk
