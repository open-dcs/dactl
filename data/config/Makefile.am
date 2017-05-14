configdir = $(sysconfdir)/@PACKAGE@
config_DATA = \
	dcs.xml \
	dcs-daq.xml

backenddir = $(sysconfdir)/@PACKAGE@/backend
backend_DATA = backend/sample.xml

controllerdir = $(sysconfdir)/@PACKAGE@/controller
controller_DATA = controller/sample.xml

devicedir = $(sysconfdir)/@PACKAGE@/device
device_DATA = device/sample.xml

plugindir = $(sysconfdir)/@PACKAGE@/plugin
plugin_DATA = plugin/sample.xml

EXTRA_DIST = \
	$(config_DATA) \
	$(backend_DATA) \
	$(controller_DATA) \
	$(device_DATA) \
	$(plugin_DATA)

-include $(top_srcdir)/git.mk
