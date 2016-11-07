if ENABLE_COMEDI_DEVICE

EXTRA_DIST = $(plugin_DATA)

plugindir = $(libdir)/dcs/devices
plugin_LTLIBRARIES = libdcs-device-comedi.la
dist_plugin_DATA = comedi.plugin

BUILT_SOURCES = libdcs_device_comedi_la_vala.stamp

libdcs_device_comedi_la_vala.stamp: $(libdcs_device_comedi_la_VALASOURCES)
	$(AM_V_GEN)$(VALAC) \
		$(libdcs_device_comedi_la_VALAFLAGS) \
		$(addprefix $(srcdir)/,$(libdcs_device_comedi_la_VALASOURCES)) \
		--ccode \
		&& touch $@

libdcs_device_comedi_la_public_sources = \
	dcs-comedi-device.c \
	$(NULL)

libdcs_device_comedi_la_VALASOURCES = \
	dcs-comedi-device.vala \
	$(NULL)

libdcs_device_comedi_la_SOURCES = \
	$(libdcs_device_comedi_la_VALASOURCES) \
	$(NULL)

CLEANFILES = $(BUILT_SOURCES)

libdcs_device_comedi_la_VALAFLAGS = \
	$(DEVICE_VALAFLAGS) \
	$(NULL)

libdcs_device_comedi_la_CFLAGS = \
	-DVALA_VERSION=\""$(VALA_VERSION)"\" \
	-DPACKAGE_DATADIR=\""$(datadir)/dcs-0.1"\" \
	-DG_LOG_DOMAIN=\"comedi-device\" \
	-DGETTEXT_PACKAGE=\"dcs\" \
	$(DEVICE_CFLAGS) \
	$(LIBDCS_DAQ_CFLAGS) \
	-Wno-deprecated-declarations \
	-Wno-discarded-qualifiers \
	-Wno-implicit-function-declaration \
	-Wno-incompatible-pointer-types \
	-Wno-unused-but-set-variable \
	-Wno-unused-label \
	-Wno-unused-function \
	$(NULL)

libdcs_device_comedi_la_LIBADD = $(DEVICE_LIBS)

libdcs_device_comedi_la_LDFLAGS = \
	$(DEVICE_LDFLAGS) \
	$(LIBDCS_DAQ_LDFLAGS) \
	$(NULL)

include $(top_srcdir)/src/devices/Makefile.device

endif

-include $(top_srcdir)/git.mk
