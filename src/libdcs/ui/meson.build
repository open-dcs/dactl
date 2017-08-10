if get_option('with-ui')

libdcs_ui_resources = gnome.compile_resources('libdcs-ui-resources',
  'libdcs-ui.gresource.xml',
  c_name: 'libdcs_ui',
)

libdcs_ui_generated_headers = libdcs_generated_headers + [
  libdcs_ui_resources[1],
]

libdcs_ui_sources = libdcs_ui_generated_headers + [
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

libdcs_ui_c_args = common_c_args + [
  '-DG_LOG_DOMAIN="DcsUI"',
]

libdcs_ui_vala_args = common_vala_args + [
  '--pkg', 'gsl',
]

libdcs_ui_deps = [
  libdcs_core_dep,
  dep_gtk,
  dep_gtksource,
  dep_rsvg,
]

if get_option('with-webkit')
  libdcs_ui_deps += [dependency('webkit2gtk-4.0', version: '>= 2.12.0')]
  #libdcs_ui_deps += [dependency('webkit2gtk-web-extension-4.0', version: '>= 2.12.0')]
  libdcs_ui_sources += [
    'dcs-ui-rich-content.vala',
    'dcs-ui-webkit-widget.vala',
    #'extensions/dcs-ui-extension-dom.vala',
  ]
  libdcs_ui_vala_args += [
    '--pkg', 'javascriptcoregtk-3.0',
  ]
endif

libdcs_ui = library('dcs-ui-' + libdcs_api_version, libdcs_ui_resources + libdcs_ui_sources,
  link_depends: 'dcs-ui.map',
     link_args: [ '-Wl,--version-script,' + join_paths(meson.current_source_dir(), 'dcs-ui.map') ],
   vala_header: 'dcs-ui.h',
     vala_args: libdcs_ui_vala_args,
     vala_vapi: 'dcs-ui-@0@.vapi'.format(libdcs_api_version),
      vala_gir: 'Dcs-@0@.gir'.format(libdcs_api_version),
  dependencies: libdcs_ui_deps,
        c_args: libdcs_ui_c_args,
     soversion: soversion,
       install: true,
   install_dir: [ true, true, true, false ],
)

libdcs_ui_girdir = meson.current_build_dir()

# XXX not sure if deps were done correctly here
libdcs_ui_dep = declare_dependency(
              sources: libdcs_ui_generated_headers,
         dependencies: libdcs_ui_deps,
            link_with: libdcs_ui,
  include_directories: include_directories('.'),
)

# Doesn't link to libdcs_ui
libdcs_ui_plugin_dep = declare_dependency(
              sources: libdcs_ui_generated_headers,
         dependencies: libdcs_ui_deps,
  include_directories: include_directories('.'),
)

pkgg = import('pkgconfig')

pkgg.generate(
    libraries: [libdcs_ui],
      subdirs: [ 'dcs-@0@'.format(meson.project_version()) ],
      version: meson.project_version(),
         name: 'libdcs-ui',
     filebase: 'libdcs-ui-@0@'.format(libdcs_api_version),
  description: 'Gtk UI widgets for OpenDCS',
     requires: [ 'gtk+-3.0', 'gtksourceview-3.0', 'librsvg-2.0', 'gsl' ],
  install_dir: join_paths(pkglibdir, 'pkgconfig'),
)

endif
