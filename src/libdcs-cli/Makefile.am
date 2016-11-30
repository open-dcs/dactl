CLEANFILES =
DISTCLEANFILES =
BUILT_SOURCES =
EXTRA_DIST =

libdcscliincdir = $(includedir)/dcs-0.2
libdcscliinc_HEADERS = dcs-cli.h

pkglibdir = $(libdir)/dcs
pkglib_LTLIBRARIES = libdcs-cli-0.2.la

headersdir = $(includedir)/dcs-@VERSION@/libdcs-cli
nobase_headers_DATA =

pkgconfig_DATA = dcs-cli-0.2.pc
pkgconfigdir = $(libdir)/pkgconfig

LIBDCS_CLI_VERSION=0:2:0

libdcs_cli_0_2_la_public_headers = \
	$(NULL)

libdcs_cli_0_2_la_public_sources = \
	dcs-cli-application.c \
	dcs-cli-factory.c \
	$(NULL)

libdcs_cli_0_2_la_VALASOURCES = \
	dcs-cli-application.vala \
	dcs-cli-factory.vala \
	$(NULL)

libdcs_cli_0_2_la_SOURCES = \
	$(libdcs_cli_0_2_la_VALASOURCES) \
	$(NULL)

libdcs_cli_0_2_la_includes = \
	$(DEBUG_CFLAGS) \
	-DPACKAGE_DATADIR="\"${datadir}\"" \
	-DPACKAGE_LOCALE_DIR=\""${datadir}/locale"\" \
	-DPACKAGE_LIBDIR=\""${libdir}"\" \
	-DBUILDDIR=\""${abs_top_builddir}"\" \
	-DSRCDIR=\""${abs_top_srcdir}"\" \
	-I$(top_srcdir)/src/libdcs-core \
	$(NULL)

libdcs_cli_0_2_la_VALAFLAGS = \
	-H dcs-cli.h -C \
	--library=dcs-cli-0.2 \
	--gir=Dcs-0.2.gir \
	--vapidir=$(top_srcdir)/vapi \
	--vapidir=$(top_srcdir)/src/libdcs-core \
	--pkg posix \
	--pkg gio-2.0 \
	--pkg gee-0.8 \
	--pkg dcs-core-0.2 \
	$(COVERAGE_VALAFLAGS) \
	$(NULL)

libdcs_cli_0_2_la_CFLAGS = \
	-DG_LOG_DOMAIN=\"libdcs-cli\" \
	-DGETTEXT_PACKAGE=\"dcs\" \
	$(AM_CFLAGS) \
	$(LIBDCS_CFLAGS) \
	$(LIBDCS_CLI_CFLAGS) \
	$(COVERAGE_CFLAGS) \
	$(OPTIMIZE_CFLAGS) \
	$(DEBUG_CFLAGS) \
	$(libdcs_cli_0_2_la_includes) \
	-Wno-deprecated-declarations \
	-Wno-discarded-qualifiers \
	-Wno-implicit-function-declaration \
	-Wno-incompatible-pointer-types \
	-Wno-unused-but-set-variable \
	-Wno-unused-label \
	-Wno-unused-function \
	$(NULL)

libdcs_cli_0_2_la_LDFLAGS = \
	$(OPTIMIZE_LDFLAGS) \
	-version-info $(LIBDCS_CLI_VERSION) \
	$(NULL)

libdcs_cli_0_2_la_LIBADD = \
	$(LIBDCS_LIBS) \
	$(LIBDCS_CLI_LIBS) \
	$(COVERAGE_LIBS) \
	$(NULL)


if HAVE_INTROSPECTION
-include $(INTROSPECTION_MAKEFILE)

INTROSPECTION_GIRS =
INTROSPECTION_SCANNER_ARGS = --add-include-path=$(srcdir) --warn-all
INTROSPECTION_COMPILER_ARGS = \
	-l libdcs-cli-0.2.so.0 \
	--includedir=$(builddir)/../libdcs-core \
	--includedir=$(srcdir)/../libdcs-core
$(builddir)/DcsCLI-0.2.gir: $(srcdir)/Dcs-0.2.gir
	$(AM_V_GEN)$(SED) \
		-e 's,Dcs\.,DcsCLI.,g' \
		-e 's,namespace name="Dcs",namespace name="DcsCLI",g' \
		-e 's,<package name="dcs-cli-0.2"/>,<include name="DcsCore" version="0.2"/>\n<package name="dcs-cli-0.2"/>,' \
		$< >$@
GIRS = DcsCLI-0.2.gir

girdir = $(datadir)/dcs/gir-1.0
gir_DATA = $(GIRS)

typelibdir = $(pkglibdir)/girepository-1.0
typelib_DATA = $(GIRS:.gir=.typelib)

CLEANFILES += $(gir_DATA) $(typelib_DATA)
endif


libdcs_cli_0_2_vapi_DEPS = \
	gio-2.0 \
	libpeas-1.0

dcs-cli-0.2.deps: Makefile
	$(AM_V_GEN) echo $(libdcs_cli_0_2_vapi_DEPS) | tr ' ' '\n' > $@

VAPI_FILES = dcs-cli-0.2.vapi
DEPS_FILES = dcs-cli-0.2.deps

vapidir = $(VAPIDIR)
vapi_DATA = $(VAPI_FILES) $(DEPS_FILES)
dcs-cli.h dcs-cli-0.2.vapi Dcs-0.2.gir: libdcs_cli_0_2_la_vala.stamp

BUILT_SOURCES += \
	dcs-cli.h \
	$(VAPI_FILES) \
	$(DEPS_FILES) \
	DcsCLI-0.2.gir \
	Dcs-0.2.gir \
	$(NULL)

EXTRA_DIST += \
	$(BUILT_SOURCES) \
	$(NULL)

-include $(top_srcdir)/git.mk
