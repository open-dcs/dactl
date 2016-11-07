gsettings_SCHEMAS = \
	org.opendcs.dcsg.gschema.xml \
	org.opendcs.dcsg.plugin.gschema.xml \
	org.opendcs.dcs.daq.device.gschema.xml \
	org.opendcs.dcs.log.backend.gschema.xml \
	org.opendcs.dcs.control.loop.gschema.xml \
	$(NULL)

.PRECIOUS: $(gsettings_SCHEMAS)

@GSETTINGS_RULES@

EXTRA_DIST = $(gsettings_SCHEMAS)

-include $(top_srcdir)/git.mk
