libdcs_daq_sources = [
  'dcs-daq-channel.vala',
  'dcs-daq-device-manager.vala',
  'dcs-daq-device.vala',
  'dcs-daq-factory.vala',
  'dcs-daq-port.vala',
  'dcs-daq-sensor.vala',
  'dcs-daq-serial-port.vala',
  'dcs-daq-signal.vala',
  'dcs-daq-task.vala',
]

libdcs_daq_c_args = common_c_args + [
  '-DG_LOG_DOMAIN="DcsDAQ"',
]

libdcs_daq_vala_args = common_vala_args + []

libdcs_daq_deps = [
  libdcs_net_dep,
]

libdcs_daq = library('dcs-daq-' + libdcs_api_version, libdcs_daq_sources + libdcs_generated_headers,
  link_depends: 'dcs-daq.map',
     link_args: [ '-Wl,--version-script,' + join_paths(meson.current_source_dir(), 'dcs-daq.map') ],
   vala_header: 'dcs-daq.h',
     vala_args: libdcs_daq_vala_args,
     vala_vapi: 'dcs-daq-@0@.vapi'.format(libdcs_api_version),
      vala_gir: 'Dcs-@0@.gir'.format(libdcs_api_version),
  dependencies: libdcs_daq_deps,
        c_args: libdcs_daq_c_args,
     soversion: soversion,
       install: true,
   install_dir: [ true, true, true, false ],
)

libdcs_daq_girdir = meson.current_build_dir()

# XXX not sure if deps were done correctly here
libdcs_daq_dep = declare_dependency(
              sources: libdcs_generated_headers,
         dependencies: libdcs_daq_deps,
            link_with: libdcs_daq,
  include_directories: include_directories('.'),
)

# Doesn't link to libdcs_daq
libdcs_daq_plugin_dep = declare_dependency(
              sources: libdcs_generated_headers,
         dependencies: libdcs_daq_deps,
  include_directories: include_directories('.'),
)

pkgg = import('pkgconfig')

pkgg.generate(
    libraries: [libdcs_daq],
      subdirs: [ 'dcs-@0@'.format(meson.project_version()) ],
      version: meson.project_version(),
         name: 'libdcs-daq',
     filebase: 'libdcs-daq-@0@'.format(libdcs_api_version),
  description: 'API for OpenDCS data acquisition classes',
     requires: [ 'gio-2.0', 'gee-0.8', 'json-glib-1.0' ],
  install_dir: join_paths(pkglibdir, 'pkgconfig'),
)
