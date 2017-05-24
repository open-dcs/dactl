CLEANFILES =
DISTCLEANFILES =
BUILT_SOURCES =
EXTRA_DIST =

bin_PROGRAMS = dcs-control

dcs_control_VALAFLAGS = \
	-H $(srcdir)/libdcs-control.h -C -c --thread \
	--vapidir=$(top_srcdir)/vapi \
	--vapidir=$(top_srcdir)/src/libdcs-core \
	--vapidir=$(top_srcdir)/src/libdcs-cli \
	--vapidir=$(top_srcdir)/src/libdcs-control \
	--vapidir=$(top_srcdir)/src/libdcs-net \
	--pkg posix \
	--pkg gio-2.0 \
	--pkg gee-0.8 \
	--pkg json-glib-1.0 \
	--pkg libsoup-2.4 \
	--pkg libzmq \
	--pkg dcs-build \
	--pkg dcs-core-0.2 \
	--pkg dcs-cli-0.2 \
	--pkg dcs-control-0.2 \
	--pkg dcs-net-0.2 \
	$(NULL)

dcs_control_includes = \
	--include config.h \
	-DLOCALEDIR=\""$(datadir)/locale"\" \
	-DDATADIR=\""$(shareddir)"\" \
	-I$(top_srcdir)/src/libdcs-core \
	-I$(top_srcdir)/src/libdcs-cli \
	-I$(top_srcdir)/src/libdcs-control \
	-I$(top_srcdir)/src/libdcs-net \
	$(NULL)

dcs_control_CFLAGS = \
	-DG_LOG_DOMAIN=\"dcs-control\" \
	-DGETTEXT_PACKAGE=\"dcs\" \
	$(LIBDCS_CFLAGS) \
	$(LIBDCS_CLI_CFLAGS) \
	$(LIBDCS_CONTROL_CFLAGS) \
	$(LIBDCS_NET_CFLAGS) \
	$(DEBUG_CFLAGS) \
	$(OPTIMIZE_CFLAGS) \
	$(dcs_control_includes) \
	-Wno-deprecated-declarations \
	-Wno-discarded-qualifiers \
	-Wno-implicit-function-declaration \
	-Wno-incompatible-pointer-types \
	-Wno-unused-but-set-variable \
	-Wno-unused-label \
	-Wno-unused-function \
	$(NULL)

dcs_control_LDADD = \
	$(LIBDCS_LIBS) \
	$(LIBDCS_CLI_LIBS) \
	$(LIBDCS_NET_LIBS) \
	$(top_builddir)/src/libdcs-core/libdcs-core-0.2.la \
	$(top_builddir)/src/libdcs-cli/libdcs-cli-0.2.la \
	$(top_builddir)/src/libdcs-control/libdcs-control-0.2.la \
	$(top_builddir)/src/libdcs-net/libdcs-net-0.2.la \
	$(NULL)

dcs_control_headers = \
	libdcs-control.h \
	$(NULL)

dcs_control_SOURCES = \
	main.vala \
	config.vala \
	cmdline-config.vala \
	server.vala \
	dbus-service.vala \
	router.vala \
	$(NULL)

BUILT_SOURCES += libdcs-control.h

-include $(top_srcdir)/git.mk
