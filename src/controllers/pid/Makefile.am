if ENABLE_PID_CONTROLLER

EXTRA_DIST = $(plugin_DATA)

plugindir = $(libdir)/dcs/controllers
plugin_LTLIBRARIES = libdcs-controller-pid.la
dist_plugin_DATA = pid.plugin

BUILT_SOURCES = libdcs_controller_pid_la_vala.stamp

libdcs_controller_pid_la_vala.stamp: $(libdcs_controller_pid_la_VALASOURCES)
	$(AM_V_GEN)$(VALAC) \
		$(libdcs_controller_pid_la_VALAFLAGS) \
		$(addprefix $(srcdir)/,$(libdcs_controller_pid_la_VALASOURCES)) \
		--ccode \
		&& touch $@

libdcs_controller_pid_la_public_sources = \
	dcs-pid-controller.c \
	dcs-pid-service-addin.c \
	$(NULL)

libdcs_controller_pid_la_VALASOURCES = \
	dcs-pid-controller.vala \
	dcs-pid-service-addin.vala \
	$(NULL)

libdcs_controller_pid_la_SOURCES = \
	$(libdcs_controller_pid_la_VALASOURCES) \
	$(NULL)

CLEANFILES = $(BUILT_SOURCES)

libdcs_controller_pid_la_VALAFLAGS = \
	$(CONTROLLER_VALAFLAGS) \
	$(NULL)

libdcs_controller_pid_la_CFLAGS = \
	-DVALA_VERSION=\""$(VALA_VERSION)"\" \
	-DPACKAGE_DATADIR=\""$(datadir)/dcs-0.2"\" \
	-DG_LOG_DOMAIN=\"pid-controller\" \
	-DGETTEXT_PACKAGE=\"dcs\" \
	$(CONTROLLER_CFLAGS) \
	$(LIBDCS_CONTROL_CFLAGS) \
	-Wno-deprecated-declarations \
	-Wno-discarded-qualifiers \
	-Wno-implicit-function-declaration \
	-Wno-incompatible-pointer-types \
	-Wno-unused-but-set-variable \
	-Wno-unused-label \
	-Wno-unused-function \
	$(NULL)

libdcs_controller_pid_la_LIBADD = $(CONTROLLER_LIBS)

libdcs_controller_pid_la_LDFLAGS = \
	$(CONTROLLER_LDFLAGS) \
	$(LIBDCS_CONTROL_LDFLAGS) \
	$(NULL)

include $(top_srcdir)/src/controllers/Makefile.controller

endif

-include $(top_srcdir)/git.mk
