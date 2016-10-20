CLEANFILES =
DISTCLEANFILES =
BUILT_SOURCES =
EXTRA_DIST =

if ENABLE_UI

include $(top_srcdir)/common.am

bin_PROGRAMS = dcsg

gresource_file = $(top_srcdir)/data/dcsg.gresource.xml

dcsg_VALAFLAGS = \
	-H $(srcdir)/libdcsg.h -C -c \
	--target-glib=2.44 \
	--thread \
	--gresources $(gresource_file) \
	$(DCS_CLD_DEPS_VALAFLAGS) \
	--vapidir=$(top_srcdir)/vapi \
	--vapidir=$(top_srcdir)/src/libdcs-core \
	--vapidir=$(top_srcdir)/src/libdcs-ui \
	--pkg posix \
	--pkg linux \
	--pkg glib-extra \
	--pkg gtksourceview-3.0 \
	--pkg json-glib-1.0 \
	--pkg dcs-config \
	--pkg dcs-core-0.1 \
	--pkg dcs-ui-0.1

dcsg_includes = \
	$(DEBUG_CFLAGS) \
	-include config.h \
	-DLOCALEDIR=\""$(datadir)/locale"\" \
	-DDATADIR=\""$(sharedir)"\" \
	-I$(top_srcdir)/src/libdcs-core \
	-I$(top_srcdir)/src/libdcs-ui

dcsg_CFLAGS = \
	-DG_LOG_DOMAIN=\"dcs\" \
	-DGETTEXT_PACKAGE=\"dcs\" \
	$(DCS_CLD_DEPS_CFLAGS) \
	$(LIBDCS_CORE_CFLAGS) \
	$(LIBDCS_UI_CFLAGS) \
	$(OPTIMIZE_CFLAGS) \
	$(dcsg_includes) \
	-Wno-deprecated-declarations \
	-Wno-discarded-qualifiers \
	-Wno-implicit-function-declaration \
	-Wno-incompatible-pointer-types \
	-Wno-unused-but-set-variable \
	-Wno-unused-label \
	-Wno-unused-function \
	-Wformat-nonliteral

dcsg_LDADD = \
	$(DCS_CLD_DEPS_LIBS) \
	$(LIBDCS_CORE_LIBS) \
	$(LIBDCS_UI_LIBS) \
	$(top_builddir)/src/libdcs-core/libdcs-core-0.1.la \
	$(top_builddir)/src/libdcs-ui/libdcs-ui-0.1.la


if ENABLE_WEBKIT
dcsg_VALAFLAGS += --pkg webkit2gtk-4.0
dcsg_CFLAGS += \
	-DWEB_EXTENSION_DIR=\""$(extensiondir)"\" \
	$(WEBKIT_CFLAGS) \
	$(NULL)
dcsg_LDADD += $(WEBKIT_LIBS)
endif


dcsg_headers = \
	dcsg.h \
	libdcsg.h \
	$(NULL)

resource_files = $(shell $(GLIB_COMPILE_RESOURCES) --generate-dependencies --sourcedir=$(top_srcdir)/data $(gresource_file))
resources.c: $(gresource_file) $(resource_files)
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) --target=$@ --sourcedir=$(top_srcdir)/data --generate-source $<

BUILT_SOURCES += resources.c

dcsg_SOURCES = \
	$(BUILT_SOURCES) \
	dcsg-application.vala \
	dcsg-application-model.vala \
	dcsg-application-view.vala \
	dcsg-application-controller.vala \
	dcsg-application-menu.vala \
	dcsg-application-toolbar.vala \
	dcsg-cmdline-config.vala \
	dcsg-configuration-editor.vala \
	dcsg-configuration-toolbar.vala \
	dcsg-csv-export.vala \
	dcsg-csv-export-toolbar.vala \
	dcsg-dbus-service.vala \
	dcsg-general-settings.vala \
	dcsg-loader.vala \
	dcsg-loader-toolbar.vala \
	dcsg-main.vala \
	dcsg-settings-data.vala \
	dcsg-settings-dialog.vala \
	dcsg-settings-listbox.vala \
	dcsg-settings-page.vala \
	dcsg-settings-sidebar.vala \
	dcsg-settings-topbar.vala \
	dcsg-settings-toolbar.vala \
	dcsg-settings-treeview.vala \
	dcsg-sidebar.vala \
	dcsg-topbar.vala \
	dcsg-utility.vala \
	dcsg-ux-manager.vala \
	$(NULL)

MAINTAINERCLEANFILES += $(BUILT_SOURCES)

CLEANFILES += \
	*.stamp \
	stamp-h1 \
	$(srcdir)/libdcsg.h \
	$(NULL)

EXTRA_DIST += \
	$(gresource_file) \
	$(BUILT_SOURCES) \
	$(NULL)

endif

-include $(top_srcdir)/git.mk
