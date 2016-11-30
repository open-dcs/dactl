CLEANFILES =
DISTCLEANFILES =
BUILT_SOURCES =
EXTRA_DIST =

libdcsnetincdir = $(includedir)/dcs-0.2
libdcsnetinc_HEADERS = dcs-net.h

pkglibdir = $(libdir)/dcs
pkglib_LTLIBRARIES = libdcs-net-0.2.la

headersdir = $(includedir)/dcs-@VERSION@/libdcs-net
nobase_headers_DATA =

pkgconfig_DATA = dcs-net-0.2.pc
pkgconfigdir = $(libdir)/pkgconfig

LIBDCS_NET_VERSION=0:2:0

libdcs_net_0_2_la_public_headers = \
	$(NULL)

libdcs_net_0_2_la_public_sources = \
	dcs-net-enum.c \
	dcs-net-factory.c \
	dcs-net-rest-service.c \
	dcs-net-zmq-service.c \
	dcs-net-zmq-client.c \
	$(NULL)

libdcs_net_0_2_la_VALASOURCES = \
	dcs-net-enum.vala \
	dcs-net-factory.vala \
	dcs-net-rest-service.vala \
	dcs-net-zmq-service.vala \
	dcs-net-zmq-client.vala \
	$(NULL)

libdcs_net_0_2_la_SOURCES = \
	$(libdcs_net_0_2_la_VALASOURCES) \
	$(NULL)

libdcs_net_0_2_la_includes = \
	$(DEBUG_CFLAGS) \
	-DPACKAGE_DATADIR="\"${datadir}\"" \
	-DPACKAGE_LOCALE_DIR=\""${datadir}/locale"\" \
	-DPACKAGE_LIBDIR=\""${libdir}"\" \
	-DBUILDDIR=\""${abs_top_builddir}"\" \
	-DSRCDIR=\""${abs_top_srcdir}"\" \
	-I$(top_srcdir)/src/libdcs-core \
	$(NULL)

libdcs_net_0_2_la_VALAFLAGS = \
	-H dcs-net.h -C \
	--library=dcs-net-0.2 \
	--gir=Dcs-0.2.gir \
	--vapidir=$(top_srcdir)/vapi \
	--vapidir=$(top_srcdir)/src/libdcs-core \
	--pkg posix \
	--pkg gio-2.0 \
	--pkg gee-0.8 \
	--pkg json-glib-1.0 \
	--pkg libsoup-2.4 \
	--pkg libzmq \
	--pkg dcs-core-0.2 \
	$(COVERAGE_VALAFLAGS) \
	$(NULL)

libdcs_net_0_2_la_CFLAGS = \
	-DG_LOG_DOMAIN=\"libdcs-net\" \
	-DGETTEXT_PACKAGE=\"dcs\" \
	$(AM_CFLAGS) \
	$(LIBDCS_CFLAGS) \
	$(LIBDCS_NET_CFLAGS) \
	$(COVERAGE_CFLAGS) \
	$(OPTIMIZE_CFLAGS) \
	$(libdcs_net_0_2_la_includes) \
	-Wno-deprecated-declarations \
	-Wno-discarded-qualifiers \
	-Wno-implicit-function-declaration \
	-Wno-incompatible-pointer-types \
	-Wno-unused-but-set-variable \
	-Wno-unused-label \
	-Wno-unused-function \
	-Wformat-nonliteral \
	$(NULL)

libdcs_net_0_2_la_LDFLAGS = \
	$(OPTIMIZE_LDFLAGS) \
	-version-info $(LIBDCS_NET_VERSION) \
	$(NULL)

libdcs_net_0_2_la_LIBADD = \
	$(LIBDCS_LIBS) \
	$(LIBDCS_NET_LIBS) \
	$(COVERAGE_LIBS) \
	$(NULL)


if HAVE_INTROSPECTION
-include $(INTROSPECTION_MAKEFILE)

INTROSPECTION_GIRS =
INTROSPECTION_SCANNER_ARGS = --add-include-path=$(srcdir) --warn-all
INTROSPECTION_COMPILER_ARGS = \
	-l libdcs-net-0.2.so.0 \
	--includedir=$(builddir)/../libdcs-core \
	--includedir=$(srcdir)/../libdcs-core
$(builddir)/DcsNet-0.2.gir: $(srcdir)/Dcs-0.2.gir
	$(AM_V_GEN)$(SED) \
		-e 's,Dcs\.,DcsNet.,g' \
		-e 's,namespace name="Dcs",namespace name="DcsNet",g' \
		-e 's,<package name="dcs-net-0.2"/>,<include name="DcsCore" version="0.2"/>\n<package name="dcs-net-0.2"/>,' \
		$< >$@
GIRS = DcsNet-0.2.gir

girdir = $(datadir)/dcs/gir-1.0
gir_DATA = $(GIRS)

typelibdir = $(pkglibdir)/girepository-1.0
typelib_DATA = $(GIRS:.gir=.typelib)

CLEANFILES += $(gir_DATA) $(typelib_DATA)
endif


libdcs_net_0_2_vapi_DEPS = \
	posix \
	json-glib-1.0 \
	libsoup-2.4 \
	libzmq

dcs-net-0.2.deps: Makefile
	$(AM_V_GEN) echo $(libdcs_net_0_2_vapi_DEPS) | tr ' ' '\n' > $@

VAPI_FILES = dcs-net-0.2.vapi
DEPS_FILES = dcs-net-0.2.deps

vapidir = $(VAPIDIR)
vapi_DATA = $(VAPI_FILES) $(DEPS_FILES)
dcs-net.h dcs-net-0.2.vapi Dcs-0.2.gir: libdcs_net_0_2_la_vala.stamp

BUILT_SOURCES += \
	dcs-net.h \
	$(VAPI_FILES) \
	$(DEPS_FILES) \
	DcsNet-0.2.gir \
	Dcs-0.2.gir \
	$(NULL)

EXTRA_DIST += \
	$(BUILT_SOURCES) \
	$(NULL)

-include $(top_srcdir)/git.mk
