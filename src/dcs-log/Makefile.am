CLEANFILES =
DISTCLEANFILES =
BUILT_SOURCES =
EXTRA_DIST =

bin_PROGRAMS = dcs-log

dcs_log_VALAFLAGS = \
	-H $(srcdir)/libdcs-log.h -C -c --thread \
	--vapidir=$(top_srcdir)/vapi \
	--vapidir=$(top_srcdir)/src/libdcs-core \
	--vapidir=$(top_srcdir)/src/libdcs-cli \
	--vapidir=$(top_srcdir)/src/libdcs-log \
	--vapidir=$(top_srcdir)/src/libdcs-net \
	--pkg posix \
	--pkg gio-2.0 \
	--pkg gee-0.8 \
	--pkg json-glib-1.0 \
	--pkg libsoup-2.4 \
	--pkg libzmq \
	--pkg dcs-config \
	--pkg dcs-core-0.1 \
	--pkg dcs-cli-0.1 \
	--pkg dcs-log-0.1 \
	--pkg dcs-net-0.1 \
	$(NULL)

dcs_log_includes = \
	--include config.h \
	-DLOCALEDIR=\""$(datadir)/locale"\" \
	-DDATADIR=\""$(shareddir)"\" \
	-I$(top_srcdir)/src/libdcs-core \
	-I$(top_srcdir)/src/libdcs-cli \
	-I$(top_srcdir)/src/libdcs-log \
	-I$(top_srcdir)/src/libdcs-net \
	$(NULL)

dcs_log_CFLAGS = \
	-DG_LOG_DOMAIN=\"dcs-log\" \
	-DGETTEXT_PACKAGE=\"dcs\" \
	$(LIBDCS_CFLAGS) \
	$(LIBDCS_CLI_CFLAGS) \
	$(LIBDCS_LOG_CFLAGS) \
	$(LIBDCS_NET_CFLAGS) \
	$(DEBUG_CFLAGS) \
	$(OPTIMIZE_CFLAGS) \
	$(dcs_log_includes) \
	-Wno-deprecated-declarations \
	-Wno-discarded-qualifiers \
	-Wno-implicit-function-declaration \
	-Wno-incompatible-pointer-types \
	-Wno-unused-but-set-variable \
	-Wno-unused-label \
	-Wno-unused-function \
	-Wformat-nonliteral \
	$(NULL)

dcs_log_LDADD = \
	$(LIBDCS_LIBS) \
	$(LIBDCS_CLI_LIBS) \
	$(LIBDCS_NET_LIBS) \
	$(top_builddir)/src/libdcs-core/libdcs-core-0.1.la \
	$(top_builddir)/src/libdcs-cli/libdcs-cli-0.1.la \
	$(top_builddir)/src/libdcs-log/libdcs-log-0.1.la \
	$(top_builddir)/src/libdcs-net/libdcs-net-0.1.la \
	$(NULL)

dcs_log_headers = \
	libdcs-log.h \
	$(NULL)

dcs_log_SOURCES = \
	main.vala \
	server.vala \
	dbus-service.vala \
	rest-service.vala \
	zmq-service.vala \
	zmq-client.vala \
	$(NULL)

BUILT_SOURCES += libdcs-log.h

-include $(top_srcdir)/git.mk
