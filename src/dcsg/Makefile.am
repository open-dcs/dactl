CLEANFILES =
DISTCLEANFILES =
BUILT_SOURCES =
EXTRA_DIST =

include $(top_srcdir)/common.am

bin_PROGRAMS = dcsg

gresource_file = $(top_srcdir)/data/dcsg.gresource.xml

dcsg_VALAFLAGS = \
	-H $(srcdir)/libdcsg.h -C -c \
	--target-glib=2.44 \
	--thread \
	--gresources $(gresource_file) \
	$(DCS_DEPS_VALAFLAGS) \
	$(DCS_CLD_DEPS_VALAFLAGS) \
	$(DCS_UI_DEPS_VALAFLAGS) \
	$(DCS_COMMON_LIBDCS_CORE_VALAFLAGS) \
	$(DCS_COMMON_LIBDCS_UI_VALAFLAGS) \
	$(DCS_COMMON_VALAFLAGS) \
	--vapidir=$(top_srcdir)/vapi \
	--pkg posix \
	--pkg linux \
	--pkg json-glib-1.0

dcsg_includes = \
	$(DEBUG_CFLAGS) \
	-include config.h \
	-DLOCALEDIR=\""$(datadir)/locale"\" \
	-DDATADIR=\""$(sharedir)"\"

dcsg_CFLAGS = \
	-DG_LOG_DOMAIN=\"dcs\" \
	-DGETTEXT_PACKAGE=\"dcs\" \
	$(DCS_DEPS_CFLAGS) \
	$(DCS_CLD_DEPS_CFLAGS) \
	$(DCS_UI_DEPS_CFLAGS) \
	$(DCS_COMMON_LIBDCS_CORE_CFLAGS) \
	$(DCS_COMMON_LIBDCS_UI_CFLAGS) \
	$(LIBDCS_CFLAGS) \
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
	$(DCS_DEPS_LIBS) \
	$(DCS_CLD_DEPS_LIBS) \
	$(DCS_UI_DEPS_LIBS) \
	$(DCS_COMMON_LIBDCS_CORE_LIBS) \
	$(DCS_COMMON_LIBDCS_UI_LIBS) \
	$(LIBDCS_LIBS) \
	$(LIBDCS_UI_LIBS)


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

-include $(top_srcdir)/git.mk
