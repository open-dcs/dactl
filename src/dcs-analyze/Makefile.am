CLEANFILES =
DISTCLEANFILES =
BUILT_SOURCES =
EXTRA_DIST =

bin_PROGRAMS = dcs-analyze

dcs_analyze_VALAFLAGS = \
	-H $(srcdir)/libdcs-analyze.h -C -c --thread \
	--vapidir=$(top_srcdir)/vapi \
	--vapidir=$(top_srcdir)/src/libdcs-core \
	--vapidir=$(top_srcdir)/src/libdcs-cli \
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
	--pkg dcs-net-0.1 \
	$(NULL)

dcs_analyze_includes = \
	-include config.h \
	-DLOCALEDIR=\""$(datadir)/locale"\" \
	-DDATADIR=\""$(shareddir)"\" \
	-I$(top_srcdir)/src/libdcs-core \
	-I$(top_srcdir)/src/libdcs-cli \
	-I$(top_srcdir)/src/libdcs-net \
	$(NULL)

dcs_analyze_CFLAGS = \
	-DG_LOG_DOMAIN=\"dcs-analyze\" \
	-DGETTEXT_PACKAGE=\"dcs\" \
	$(LIBDCS_CFLAGS) \
	$(LIBDCS_CLI_CFLAGS) \
	$(LIBDCS_NET_CFLAGS) \
	$(DEBUG_CFLAGS) \
	$(OPTIMIZE_CFLAGS) \
	$(dcs_analyze_includes) \
	-Wno-deprecated-declarations \
	-Wno-discarded-qualifiers \
	-Wno-implicit-function-declaration \
	-Wno-incompatible-pointer-types \
	-Wno-unused-but-set-variable \
	-Wno-unused-label \
	-Wno-unused-function \
	$(NULL)

dcs_analyze_LDADD = \
	$(LIBDCS_LIBS) \
	$(LIBDCS_CLI_LIBS) \
	$(LIBDCS_NET_LIBS) \
	$(top_builddir)/src/libdcs-core/libdcs-core-0.1.la \
	$(top_builddir)/src/libdcs-cli/libdcs-cli-0.1.la \
	$(top_builddir)/src/libdcs-net/libdcs-net-0.1.la \
	$(NULL)

dcs_analyze_headers = \
	libdcs-analyze.h \
	$(NULL)

dcs_analyze_SOURCES = \
	main.vala \
	$(NULL)

BUILT_SOURCES += libdcs-analyze.h

-include $(top_srcdir)/git.mk
