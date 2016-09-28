CLEANFILES =
DISTCLEANFILES =
BUILT_SOURCES =
EXTRA_DIST =

BUILT_SOURCES += \
	dcs-daq.service \
	dcs-log.service \
	dcs-ctl.service \
	$(NULL)

EXTRA_DIST += \
	dcs-daq.service.in \
	dcs-log.service.in \
	dcs-ctl.service.in \
	$(NULL)

edit = sed \
	-e 's|@bindir[@]|$(bindir)|g' \
	-e 's|@sbindir[@]|$(sbindir)|g' \
	-e 's|@sysconfdir[@]|$(sysconfdir)|g'

dcs-daq.service: dcs-daq.service.in
	$(edit) $< >$@

dcs-log.service: dcs-log.service.in
	$(edit) $< >$@

dcs-ctl.service: dcs-ctl.service.in
	$(edit) $< >$@

install-service: install-sysconfig
	$(MKDIR_P) $(DESTDIR)$(SYSTEMD_UNITDIR)
	$(INSTALL_DATA) dcs-daq.service $(DESTDIR)$(SYSTEMD_UNITDIR)/dcs-daq.service
	$(INSTALL_DATA) dcs-log.service $(DESTDIR)$(SYSTEMD_UNITDIR)/dcs-log.service
	$(INSTALL_DATA) dcs-ctl.service $(DESTDIR)$(SYSTEMD_UNITDIR)/dcs-ctl.service

uninstall-service: uninstall-sysconfig
	rm -f $(DESTDIR)$(SYSTEMD_UNITDIR)/dcs-daq.service
	rm -f $(DESTDIR)$(SYSTEMD_UNITDIR)/dcs-log.service
	rm -f $(DESTDIR)$(SYSTEMD_UNITDIR)/dcs-ctl.service
	rmdir $(DESTDIR)$(SYSTEMD_UNITDIR) || :

-include $(top_srcdir)/git.mk
