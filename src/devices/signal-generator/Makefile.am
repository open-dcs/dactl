if ENABLE_SIGNAL_GENERATOR

deviceconfdir = $(sysconfdir)/@PACKAGE@/device
deviceconf_DATA = signal-generator.json

devicedir = $(libdir)/dcs/devices
dist_device_DATA = \
	signal-generator.py \
	signal-generator.plugin

EXTRA_DIST = $(device_DATA) $(deviceconf_DATA)

endif

-include $(top_srcdir)/git.mk
