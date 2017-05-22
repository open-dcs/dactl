include $(top_srcdir)/common.am

CLEANFILES =
DISTCLEANFILES =
BUILT_SOURCES =
EXTRA_DIST =

libdcsdaqincdir = $(includedir)/dcs-0.2
libdcsdaqinc_HEADERS = dcs-daq.h

pkglibdir = $(libdir)/dcs
pkglib_LTLIBRARIES = libdcs-daq-0.2.la

headersdir = $(includedir)/dcs-@VERSION@/libdcs-daq
nobase_headers_DATA =

pkgconfig_DATA = dcs-daq-0.2.pc
pkgconfigdir = $(libdir)/pkgconfig

LIBDCS_DAQ_VERSION=0:2:0

libdcs_daq_0_2_la_public_headers = \
	$(NULL)

libdcs_daq_0_2_la_public_sources = \
	dcs-daq-channel.c \
	dcs-daq-device.c \
	dcs-daq-device-manager.c \
	dcs-daq-factory.c \
	dcs-daq-port.c \
	dcs-daq-sensor.c \
	dcs-daq-serial-port.c \
	dcs-daq-signal.c \
	dcs-daq-task.c \
	$(NULL)

libdcs_daq_0_2_la_VALASOURCES = \
	dcs-daq-channel.vala \
	dcs-daq-device.vala \
	dcs-daq-device-manager.vala \
	dcs-daq-factory.vala \
	dcs-daq-port.vala \
	dcs-daq-sensor.vala \
	dcs-daq-serial-port.vala \
	dcs-daq-signal.vala \
	dcs-daq-task.vala \
	$(NULL)

libdcs_daq_0_2_la_SOURCES = \
	$(libdcs_daq_0_2_la_VALASOURCES) \
	$(NULL)

libdcs_daq_0_2_la_includes = \
	$(DEBUG_CFLAGS) \
	-DPACKAGE_DATADIR="\"${datadir}\"" \
	-DPACKAGE_LOCALE_DIR=\""${datadir}/locale"\" \
	-DPACKAGE_LIBDIR=\""${libdir}"\" \
	-DBUILDDIR=\""${abs_top_builddir}"\" \
	-DSRCDIR=\""${abs_top_srcdir}"\" \
	-I$(top_srcdir)/src/libdcs-core \
	-I$(top_srcdir)/src/libdcs-net \
	$(NULL)

libdcs_daq_0_2_la_VALAFLAGS = \
	-H dcs-daq.h -C \
	--library=dcs-daq-0.2 \
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

libdcs_daq_0_2_la_CFLAGS = \
	-DG_LOG_DOMAIN=\"libdcs-daq\" \
	-DGETTEXT_PACKAGE=\"dcs\" \
	-DDEVICE_DIR=\""$(devicedir)"\" \
	$(AM_CFLAGS) \
	$(LIBDCS_CFLAGS) \
	$(LIBDCS_DAQ_CFLAGS) \
	$(LIBDCS_NET_CFLAGS) \
	$(COVERAGE_CFLAGS) \
	$(OPTIMIZE_CFLAGS) \
	$(libdcs_daq_0_2_la_includes) \
	-Wno-deprecated-declarations \
	-Wno-discarded-qualifiers \
	-Wno-implicit-function-declaration \
	-Wno-incompatible-pointer-types \
	-Wno-unused-but-set-variable \
	-Wno-unused-label \
	-Wno-unused-function \
	-Wformat-nonliteral \
	$(NULL)

libdcs_daq_0_2_la_LDFLAGS = \
	$(OPTIMIZE_LDFLAGS) \
	-version-info $(LIBDCS_DAQ_VERSION) \
	$(NULL)

libdcs_daq_0_2_la_LIBADD = \
	$(LIBDCS_LIBS) \
	$(LIBDCS_DAQ_LIBS) \
	$(LIBDCS_NET_LIBS) \
	$(COVERAGE_LIBS) \
	$(NULL)


if HAVE_INTROSPECTION
-include $(INTROSPECTION_MAKEFILE)

INTROSPECTION_GIRS =
INTROSPECTION_SCANNER_ARGS = --add-include-path=$(srcdir) --warn-all
INTROSPECTION_COMPILER_ARGS = \
	-l libdcs-daq-0.2.so.0 \
	--includedir=$(builddir)/../libdcs-core \
	--includedir=$(srcdir)/../libdcs-core
$(builddir)/DcsDAQ-0.2.gir: $(srcdir)/Dcs-0.2.gir
	$(AM_V_GEN)$(SED) \
		-e 's,Dcs\.,DcsDAQ.,g' \
		-e 's,namespace name="Dcs",namespace name="DcsDAQ",g' \
		-e 's,DcsDAQ\.Node,DcsCore.Node,g' \
		-e 's,<package name="dcs-daq-0.2"/>,<include name="DcsCore" version="0.2"/>\n<package name="dcs-daq-0.2"/>,' \
		$< >$@
GIRS = DcsDAQ-0.2.gir

girdir = $(datadir)/dcs/gir-1.0
gir_DATA = $(GIRS)

typelibdir = $(pkglibdir)/girepository-1.0
typelib_DATA = $(GIRS:.gir=.typelib)

CLEANFILES += $(gir_DATA) $(typelib_DATA)
endif


libdcs_daq_0_2_vapi_DEPS = \
	posix \
	gio-2.0 \
	gee-0.8 \
	json-glib-1.0

dcs-daq-0.2.deps: Makefile
	$(AM_V_GEN) echo $(libdcs_daq_0_2_vapi_DEPS) | tr ' ' '\n' > $@

VAPI_FILES = dcs-daq-0.2.vapi
DEPS_FILES = dcs-daq-0.2.deps

vapidir = $(VAPIDIR)
vapi_DATA = $(VAPI_FILES) $(DEPS_FILES)
dcs-daq.h dcs-daq-0.2.vapi Dcs-0.2.gir: libdcs_daq_0_2_la_vala.stamp

BUILT_SOURCES += \
	dcs-daq.h \
	$(VAPI_FILES) \
	$(DEPS_FILES) \
	DcsDAQ-0.2.gir \
	Dcs-0.2.gir \
	$(NULL)

EXTRA_DIST += \
	$(BUILT_SOURCES) \
	$(NULL)

-include $(top_srcdir)/git.mk
