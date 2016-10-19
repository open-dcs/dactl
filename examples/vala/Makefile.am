include $(top_srcdir)/common.am

noinst_PROGRAMS =

example_VALAFLAGS = \
	$(DCS_DEPS_VALAFLAGS) \
	$(DCS_CLD_DEPS_VALAFLAGS) \
	--vapidir=$(top_srcdir)/vapi \
	--vapidir=$(top_srcdir)/src/libdcs-core \
	--pkg libdcs-core-0.1 \
	--pkg libdcs-config

example_CFLAGS = \
	$(DEBUG_CFLAGS) \
	$(DCS_DEPS_CFLAGS) \
	$(DCS_CLD_DEPS_CFLAGS) \
	-I$(top_srcdir)/src/libdcs-core \
	$(LIBDCS_CORE_CFLAGS)

example_LDADD = \
	$(DCS_DEPS_LIBS) \
	$(DCS_CLD_DEPS_LIBS) \
	$(LIBDCS_CORE_LIBS)

if ENABLE_UI

noinst_PROGRAMS += box channel-treeview chart chart-axis page pnid

example_ui_VALAFLAGS = \
	--vapidir=$(top_srcdir)/src/libdcs-ui \
	--pkg libdcs-ui-0.1

example_ui_CFLAGS = \
	$(LIBDCS_UI_CFLAGS)

example_ui_LDADD = \
	$(LIBDCS_UI_LIBS)

example_VALAFLAGS += example_ui_VALAFLAGS
example_CFLAGS += example_ui_CFLAGS
example_LDADD += example_LDADD

if ENABLE_WEBKIT
example_VALAFLAGS += --pkg webkit2gtk-4.0
example_CFLAGS += $(WEBKIT_CFLAGS)
example_LDADD += $(WEBKIT_LIBS)
endif

box_SOURCES = box.vala
box_DEPENDENCIES = $(example_DEPENDENCIES)
box_VALAFLAGS = $(example_VALAFLAGS)
box_CPPFLAGS = $(example_CFLAGS)
box_LDADD = $(example_LDADD)

channel_treeview_SOURCES = channel-treeview.vala
channel_treeview_DEPENDENCIES = $(example_DEPENDENCIES)
channel_treeview_VALAFLAGS = $(example_VALAFLAGS)
channel_treeview_CPPFLAGS = $(example_CFLAGS)
channel_treeview_LDADD = $(example_LDADD)

chart_SOURCES = chart.vala
chart_DEPENDENCIES = $(example_DEPENDENCIES)
chart_VALAFLAGS = $(example_VALAFLAGS)
chart_CPPFLAGS = $(example_CFLAGS)
chart_LDADD = $(example_LDADD)

chart_axis_SOURCES = chart-axis.vala
chart_axis_DEPENDENCIES = $(example_DEPENDENCIES)
chart_axis_VALAFLAGS = $(example_VALAFLAGS)
chart_axis_CPPFLAGS = $(example_CFLAGS)
chart_axis_LDADD = $(example_LDADD)

page_SOURCES = pnid.vala
page_DEPENDENCIES = $(example_DEPENDENCIES)
page_VALAFLAGS = $(example_VALAFLAGS)
page_CPPFLAGS = $(example_CFLAGS)
page_LDADD = $(example_LDADD)

pnid_SOURCES = pnid.vala
pnid_DEPENDENCIES = $(example_DEPENDENCIES)
pnid_VALAFLAGS = $(example_VALAFLAGS)
pnid_CPPFLAGS = $(example_CFLAGS)
pnid_LDADD = $(example_LDADD)

endif

-include $(top_srcdir)/git.mk
