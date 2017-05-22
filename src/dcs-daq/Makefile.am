CLEANFILES =
DISTCLEANFILES =
BUILT_SOURCES =
EXTRA_DIST =

bin_PROGRAMS = dcs-daq

dcs_daq_VALAFLAGS = \
	-H $(srcdir)/libdcs-daq.h -C -c --thread \
	--vapidir=$(top_srcdir)/vapi \
	--vapidir=$(top_srcdir)/src/libdcs-core \
	--vapidir=$(top_srcdir)/src/libdcs-cli \
	--vapidir=$(top_srcdir)/src/libdcs-daq \
	--vapidir=$(top_srcdir)/src/libdcs-net \
	--pkg posix \
	--pkg gio-2.0 \
	--pkg gee-0.8 \
	--pkg json-glib-1.0 \
	--pkg libsoup-2.4 \
	--pkg libzmq \
	--pkg template-glib-1.0 \
	--pkg dcs-build \
	--pkg dcs-core-0.2 \
	--pkg dcs-cli-0.2 \
	--pkg dcs-daq-0.2 \
	--pkg dcs-net-0.2 \
	$(NULL)

dcs_daq_includes = \
	-include config.h \
	-DLOCALEDIR=\""$(datadir)/locale"\" \
	-DDATADIR=\""$(shareddir)"\" \
	-DTMPLDIR=\""$(libdir)/@PACKAGE@/dcs-daq"\" \
	-I$(top_srcdir)/src/libdcs-core \
	-I$(top_srcdir)/src/libdcs-cli \
	-I$(top_srcdir)/src/libdcs-daq \
	-I$(top_srcdir)/src/libdcs-net \
	$(NULL)

dcs_daq_CFLAGS = \
	-DG_LOG_DOMAIN=\"dcs-daq\" \
	-DGETTEXT_PACKAGE=\"dcs\" \
	$(LIBDCS_CFLAGS) \
	$(LIBDCS_CLI_CFLAGS) \
	$(LIBDCS_DAQ_CFLAGS) \
	$(LIBDCS_NET_CFLAGS) \
	$(DEBUG_CFLAGS) \
	$(OPTIMIZE_CFLAGS) \
	$(dcs_daq_includes) \
	-Wno-deprecated-declarations \
	-Wno-discarded-qualifiers \
	-Wno-implicit-function-declaration \
	-Wno-incompatible-pointer-types \
	-Wno-unused-but-set-variable \
	-Wno-unused-label \
	-Wno-unused-function \
	-Wformat-nonliteral \
	$(NULL)

dcs_daq_LDADD = \
	$(LIBDCS_LIBS) \
	$(LIBDCS_CLI_LIBS) \
	$(LIBDCS_DAQ_LIBS) \
	$(LIBDCS_NET_LIBS) \
	$(top_builddir)/src/libdcs-core/libdcs-core-0.2.la \
	$(top_builddir)/src/libdcs-cli/libdcs-cli-0.2.la \
	$(top_builddir)/src/libdcs-daq/libdcs-daq-0.2.la \
	$(top_builddir)/src/libdcs-net/libdcs-net-0.2.la \
	$(NULL)

dcs_daq_headers = \
	libdcs-daq.h \
	$(NULL)

dcs_daq_SOURCES = \
	main.vala \
	config.vala \
	cmdline-config.vala \
	server.vala \
	dbus-service.vala \
	router.vala \
	$(NULL)

BUILT_SOURCES += libdcs-daq.h

-include $(top_srcdir)/git.mk
