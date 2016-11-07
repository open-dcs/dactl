CLEANFILES =
DISTCLEANFILES =
BUILT_SOURCES =
EXTRA_DIST =

bin_PROGRAMS = dcs

dcs_VALAFLAGS = \
	-H $(srcdir)/libdcs.h -C -c --thread \
	--target-glib=2.44 \
	--vapidir=$(top_srcdir)/vapi \
	--vapidir=$(top_srcdir)/src/libdcs-core \
	--vapidir=$(top_srcdir)/src/libdcs-cli \
	--pkg posix \
	--pkg gio-2.0 \
	--pkg gee-0.8 \
	--pkg json-glib-1.0 \
	--pkg readline \
	--pkg dcs-build \
	--pkg dcs-core-0.2 \
	--pkg dcs-cli-0.2 \
	$(NULL)

dcs_includes = \
	-include config.h \
	-DLOCALEDIR=\""$(datadir)/locale"\" \
	-DDATADIR=\""$(shareddir)"\" \
	-I/usr/include/readline \
	-I$(top_srcdir)/src/libdcs-core \
	-I$(top_srcdir)/src/libdcs-cli \
	$(NULL)

dcs_CFLAGS = \
	-DG_LOG_DOMAIN=\"dcs\" \
	-DGETTEXT_PACKAGE=\"dcs\" \
	$(LIBDCS_CORE_CFLAGS) \
	$(LIBDCS_CLI_CFLAGS) \
	$(DEBUG_CFLAGS) \
	$(OPTIMIZE_CFLAGS) \
	$(dcs_includes) \
	-Wno-deprecated-declarations \
	-Wno-discarded-qualifiers \
	-Wno-implicit-function-declaration \
	-Wno-incompatible-pointer-types \
	-Wno-unused-but-set-variable \
	-Wno-unused-label \
	-Wno-unused-function \
	-Wformat-nonliteral \
	$(NULL)

dcs_LDADD = \
	$(LIBDCS_CORE_LIBS) \
	$(LIBDCS_CLI_LIBS) \
	-lreadline \
	$(top_builddir)/src/libdcs-core/libdcs-core-0.2.la \
	$(top_builddir)/src/libdcs-cli/libdcs-cli-0.2.la \
	$(NULL)

dcs_headers = \
	libdcs.h \
	$(NULL)

dcs_SOURCES = \
	dcs-main.vala \
	dcs-command.vala \
	dcs-command-help.vala \
	dcs-command-set.vala \
	dcs-command-get.vala \
	dcs-command-publish.vala \
	dcs-command-subscribe.vala \
	dcs-command-request.vala \
	dcs-command-reply.vala \
	dcs-command-quit.vala \
	dcs-utils.vala \
	$(NULL)

BUILT_SOURCES += libdcs.h

-include $(top_srcdir)/git.mk
