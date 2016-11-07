if ENABLE_PID_LOOP

EXTRA_DIST = $(plugin_DATA)

plugindir = $(libdir)/dcs/loops
plugin_LTLIBRARIES = libdcs-loop-pid.la
dist_plugin_DATA = pid.plugin

BUILT_SOURCES = libdcs_loop_pid_la_vala.stamp

libdcs_loop_pid_la_vala.stamp: $(libdcs_loop_pid_la_VALASOURCES)
	$(AM_V_GEN)$(VALAC) \
		$(libdcs_loop_pid_la_VALAFLAGS) \
		$(addprefix $(srcdir)/,$(libdcs_loop_pid_la_VALASOURCES)) \
		--ccode \
		&& touch $@

libdcs_loop_pid_la_public_sources = \
	dcs-pid-loop.c \
	$(NULL)

libdcs_loop_pid_la_VALASOURCES = \
	dcs-pid-loop.vala \
	$(NULL)

libdcs_loop_pid_la_SOURCES = \
	$(libdcs_loop_pid_la_VALASOURCES) \
	$(NULL)

CLEANFILES = $(BUILT_SOURCES)

libdcs_loop_pid_la_VALAFLAGS = \
	$(LOOP_VALAFLAGS) \
	$(NULL)

libdcs_loop_pid_la_CFLAGS = \
	-DVALA_VERSION=\""$(VALA_VERSION)"\" \
	-DPACKAGE_DATADIR=\""$(datadir)/dcs-0.1"\" \
	-DG_LOG_DOMAIN=\"pid-loop\" \
	-DGETTEXT_PACKAGE=\"dcs\" \
	$(LOOP_CFLAGS) \
	$(LIBDCS_CONTROL_CFLAGS) \
	-Wno-deprecated-declarations \
	-Wno-discarded-qualifiers \
	-Wno-implicit-function-declaration \
	-Wno-incompatible-pointer-types \
	-Wno-unused-but-set-variable \
	-Wno-unused-label \
	-Wno-unused-function \
	$(NULL)

libdcs_loop_pid_la_LIBADD = $(LOOP_LIBS)

libdcs_loop_pid_la_LDFLAGS = \
	$(LOOP_LDFLAGS) \
	$(LIBDCS_CONTROL_LDFLAGS) \
	$(NULL)

include $(top_srcdir)/src/loops/Makefile.loop

endif

-include $(top_srcdir)/git.mk
