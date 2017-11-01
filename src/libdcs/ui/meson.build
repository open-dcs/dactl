if get_option('with-ui')

gresource = join_paths(meson.current_source_dir(), 'ui.gresource.xml')

ui_resources = gnome.compile_resources('ui-resources',
  gresource,
  c_name: 'ui',
)

ui_headers = []

libdcs_generated_headers += [ ui_resources[1] ]

ui_sources = [
  'dcs-ui-ai-control.vala',
  'dcs-ui-ao-control.vala',
  'dcs-ui-application.vala',
  'dcs-ui-box.vala',
  'dcs-ui-channel-matrix.vala',
  'dcs-ui-channel-treeview.vala',
  'dcs-ui-channel-vector.vala',
  'dcs-ui-chart-axis.vala',
  'dcs-ui-chart-colormap.vala',
  'dcs-ui-chart-trace.vala',
  'dcs-ui-chart.vala',
  'dcs-ui-chart-widget.vala',
  'dcs-ui-digital-control.vala',
  'dcs-ui-drawing.vala',
  'dcs-ui-exec-control.vala',
  'dcs-ui-factory.vala',
  'dcs-ui-foo-canvas.vala',
  'dcs-ui-foo-object.vala',
  'dcs-ui-foo-page.vala',
  'dcs-ui-foo-widget.vala',
  'dcs-ui-grid.vala',
  'dcs-ui-heatmap.vala',
  'dcs-ui-log-control.vala',
  'dcs-ui-page.vala',
  'dcs-ui-pid-control.vala',
  'dcs-ui-plugin-control.vala',
  'dcs-ui-plugin-manager.vala',
  'dcs-ui-pnid.vala',
  'dcs-ui-polar-axis.vala',
  'dcs-ui-polar-canvas.vala',
  'dcs-ui-polar-chart.vala',
  'dcs-ui-polar-heatmap.vala',
  'dcs-ui-rt-chart-trace.vala',
  'dcs-ui-rt-chart.vala',
  'dcs-ui-rt-multichannel-trace.vala',
  'dcs-ui-settable.vala',
  'dcs-ui-stripchart.vala',
  'dcs-ui-utility.vala',
  'dcs-ui-video-processor.vala',
  'dcs-ui-webkit-widget.vala',
  'dcs-ui-widget-information.vala',
  'dcs-ui-widget.vala',
  'dcs-ui-window-base.vala',
  'dcs-ui-window.vala',
]

ui_vala_args = [
  '--pkg', 'gsl',
]

if get_option('with-ui')
  dep_gtk = dependency('gtk+-3.0', version: '>= 3.22.0')
  dep_gtksource = dependency('gtksourceview-3.0', version: '>= 3.22.0')
  dep_peasgtk = dependency('libpeas-gtk-1.0', version: '>= 1.20.0')
  dep_rsvg = dependency('librsvg-2.0', version: '>= 2.40.0')
endif

ui_deps = [
  dep_gtk,
  dep_gtksource,
  dep_peasgtk,
  dep_rsvg,
]

if get_option('with-webkit')
  ui_deps += [dependency('webkit2gtk-4.0', version: '>= 2.12.0')]
  #ui_deps += [dependency('webkit2gtk-web-extension-4.0', version: '>= 2.12.0')]

  ui_vala_args += [
    '--pkg', 'javascriptcoregtk-3.0',
    '--gresources=' + gresource,
  ]

  ui_sources += [
    'dcs-ui-rich-content.vala',
    'dcs-ui-webkit-widget.vala',
    #'extensions/dcs-ui-extension-dom.vala',
  ]
endif

libdcs_deps += ui_deps
libdcs_vala_args += ui_vala_args

libdcs_headers += files(ui_headers)
libdcs_sources += files(ui_sources)

install_headers(ui_headers, subdir: join_paths(libdcs_header_subdir, 'ui'))

endif
