include $(top_srcdir)/common.am

CLEANFILES =
DISTCLEANFILES =
BUILT_SOURCES =
EXTRA_DIST =

SUBDIRS = extensions

if ENABLE_UI

include $(srcdir)/filelist.am

libdcsuiincdir = $(includedir)/dcs-0.2
libdcsuiinc_HEADERS = dcs-ui.h

pkglibdir = $(libdir)/dcs
pkglib_LTLIBRARIES = libdcs-ui-0.2.la

headersdir = $(includedir)/dcs-0.2
nobase_headers_DATA =

pkgconfig_DATA = dcs-ui-0.2.pc
pkgconfigdir = $(libdir)/pkgconfig

LIBDCS_UI_VERSION=0:2:0

gresource_file = libdcs-ui.gresource.xml
resource_files = $(shell $(GLIB_COMPILE_RESOURCES) --generate-dependencies $(gresource_file))
resources.c: $(gresource_file) $(resource_files)
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) --target=$@ --sourcedir=. --generate-source $<

BUILT_SOURCES += \
	resources.c \
	$(gresource_file) \
	$(NULL)

libdcs_ui_0_2_la_public_headers = \
	$(NULL)

libdcs_ui_0_2_la_public_sources = \
	resources.c \
	$(NULL)

libdcs_ui_0_2_la_SOURCES = \
	$(libdcs_ui_0_2_la_public_sources) \
	$(LIBDCS_UI_VAPI_SOURCE_FILES) \
	$(LIBDCS_UI_NONVAPI_SOURCE_FILES)

libdcs_ui_0_2_la_includes = \
	$(DEBUG_CFLAGS) \
	-I$(top_srcdir)/src/libdcs-core \
	-I$(top_srcdir)/src/libdcs-net \
	$(NULL)

libdcs_ui_0_2_la_VALAFLAGS = \
	--target-glib=2.44 \
	--thread \
	-H dcs-ui.h -C \
	--library=dcs-ui-0.2 \
	--gir=Dcs-0.2.gir \
	--gresources $(gresource_file) \
	--vapidir=$(top_srcdir)/vapi \
	--vapidir=$(top_srcdir)/src/libdcs-core \
	--pkg posix \
	--pkg gee-0.8 \
	--pkg glib-2.0 \
	--pkg gio-2.0 \
	--pkg gtk+-3.0 \
	--pkg gtksourceview-3.0 \
	--pkg cld-0.3 \
	--pkg libxml-2.0 \
	--pkg libpeas-1.0 \
	--pkg libpeas-gtk-1.0 \
	--pkg libsoup-2.4 \
	--pkg librsvg-2.0 \
	--pkg dcs-core-0.2 \
	--pkg dcs-build \
	$(DCS_CLD_DEPS_VALAFLAGS) \
	$(COVERAGE_VALAFLAGS)

libdcs_ui_0_2_la_CFLAGS = \
	-DWEB_EXTENSION_DIR=\""$(extensiondir)"\" \
	-DG_LOG_DOMAIN=\"libdcs-ui\" \
	-DGETTEXT_PACKAGE=\"dcs\" \
	$(AM_CFLAGS) \
	$(LIBDCS_CORE_CFLAGS) \
	$(LIBDCS_UI_CFLAGS) \
	$(DCS_CLD_DEPS_CFLAGS) \
	$(COVERAGE_CFLAGS) \
	$(OPTIMIZE_CFLAGS) \
	$(libdcs_ui_0_2_la_includes) \
	-Wno-deprecated-declarations \
	-Wno-discarded-qualifiers \
	-Wno-implicit-function-declaration \
	-Wno-incompatible-pointer-types \
	-Wno-unused-but-set-variable \
	-Wno-unused-label \
	-Wno-unused-function \
	-Wformat-nonliteral \
	-Wredundant-decls

libdcs_ui_0_2_la_LDFLAGS = \
	$(OPTIMIZE_LDFLAGS) \
	$(DCS_DATA_DIR_DEFINES) \
	-version-info $(LIBDCS_UI_VERSION)

libdcs_ui_0_2_la_LIBADD = \
	$(LIBDCS_CORE_LIBS) \
	$(LIBDCS_UI_LIBS) \
	$(DCS_CLD_DEPS_LIBS) \
	$(COVERAGE_LIBS)


if ENABLE_WEBKIT
libdcs_ui_0_2_la_SOURCES += \
	dcs-ui-webkit-widget.vala \
	dcs-ui-rich-content.vala \
	$(NULL)
libdcs_ui_0_2_la_VALAFLAGS += --pkg webkit2gtk-4.0
libdcs_ui_0_2_la_CFLAGS += $(WEBKIT_CFLAGS)
libdcs_ui_0_2_la_LIBADD += $(WEBKIT_LIBS)
libdcs_ui_0_2_la_LDFLAGS += $(WEBKIT_LDFLAGS)
endif


if HAVE_INTROSPECTION
-include $(INTROSPECTION_MAKEFILE)

INTROSPECTION_GIRS =
INTROSPECTION_SCANNER_ARGS = --add-include-path=$(srcdir) --warn-all
INTROSPECTION_COMPILER_ARGS = \
	-l libdcs-ui-0.2.so.0 \
	--includedir=$(builddir)/../libdcs-core \
	--includedir=$(srcdir)/../libdcs-core
$(builddir)/DcsUI-0.2.gir: $(srcdir)/Dcs-0.2.gir
	$(AM_V_GEN)$(SED) \
		-e 's,Dcs\.,DcsUI.,g' \
		-e 's,namespace name="Dcs",namespace name="DcsUI",g' \
		-e 's,DcsUI\.Application,DcsCore.Application,g' \
		-e 's,DcsUI\.Object,DcsCore.Object,g' \
		-e 's,DcsUI\.Buildable,DcsCore.Buildable,g' \
		-e 's,DcsUI\.Container,DcsCore.Container,g' \
		-e 's,DcsUI\.CldAdapter,DcsCore.CldAdapter,g' \
		-e 's,DcsUI\.Extension,DcsCore.Extension,g' \
		-e 's,DcsUI\.Factory,DcsCore.Factory,g' \
		-e 's,DcsUI\.Model,DcsCore.Model,g' \
		-e 's,DcsUI\.View,DcsCore.View,g' \
		-e 's,DcsUI\.Controller,DcsCore.Controller,g' \
		-e 's,DcsUI\.PluginExtension,DcsCore.PluginExtension,g' \
		-e 's,<package name="dcs-ui-0.2"/>,<include name="DcsCore" version="0.2"/>\n<package name="dcs-ui-0.2"/>,' \
		$< >$@
GIRS = DcsUI-0.2.gir

girdir = $(datadir)/gir-1.0
gir_DATA = $(GIRS)

typelibdir = $(pkglibdir)/girepository-1.0
typelib_DATA = $(GIRS:.gir=.typelib)

CLEANFILES += $(gir_DATA) $(typelib_DATA)
endif


libdcs_ui_0_2_vapi_DEPS = \
	gee-0.8 \
	gio-2.0 \
	gtk+-3.0 \
	libpeas-1.0 \
	librsvg-2.0 \
	libxml-2.0

dcs-ui-0.2.deps: Makefile
	$(AM_V_GEN) echo $(libdcs_ui_0_2_vapi_DEPS) | tr ' ' '\n' > $@

VAPI_FILES = dcs-ui-0.2.vapi
DEPS_FILES = dcs-ui-0.2.deps

vapidir = $(VAPIDIR)
vapi_DATA = $(VAPI_FILES) $(DEPS_FILES)
dcs-ui.h dcs-cli-0.2.vapi: libdcs_ui_0_2_la_vala.stamp

BUILT_SOURCES += \
	dcs-ui.h \
	$(VAPI_FILES) \
	$(DEPS_FILES) \
	DcsUI-0.2.gir \
	Dcs-0.2.gir \
	$(NULL)

EXTRA_DIST += \
	$(BUILT_SOURCES) \
	$(NULL)

endif

-include $(top_srcdir)/git.mk
