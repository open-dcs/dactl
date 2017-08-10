libdcs_control_sources = [
  'dcs-control-controller.vala',
  'dcs-control-factory.vala',
  'dcs-control-loop-manager.vala',
]

libdcs_control_vala_args = common_vala_args + []

libdcs_control_c_args = common_c_args + [
  '-DG_LOG_DOMAIN="DcsControl"',
]

libdcs_control_deps = [
  libdcs_net_dep,
]

libdcs_control = library('dcs-control-' + libdcs_api_version, libdcs_control_sources + libdcs_generated_headers,
  link_depends: 'dcs-control.map',
     link_args: [ '-Wl,--version-script,' + join_paths(meson.current_source_dir(), 'dcs-control.map') ],
   vala_header: 'dcs-control.h',
     vala_args: libdcs_control_vala_args,
     vala_vapi: 'dcs-control-@0@.vapi'.format(libdcs_api_version),
      vala_gir: 'Dcs-@0@.gir'.format(libdcs_api_version),
  dependencies: libdcs_control_deps,
        c_args: libdcs_control_c_args,
     soversion: soversion,
       install: true,
   install_dir: [ true, true, true, false ],
)

libdcs_control_girdir = meson.current_build_dir()

# XXX not sure if deps were done correctly here
libdcs_control_dep = declare_dependency(
              sources: libdcs_generated_headers,
         dependencies: libdcs_control_deps,
            link_with: libdcs_control,
  include_directories: include_directories('.'),
)

# Doesn't link to libdcs_control
libdcs_control_plugin_dep = declare_dependency(
              sources: libdcs_generated_headers,
         dependencies: libdcs_control_deps,
  include_directories: include_directories('.'),
)

pkgg = import('pkgconfig')

pkgg.generate(
    libraries: [libdcs_control],
      subdirs: [ 'dcs-@0@'.format(meson.project_version()) ],
      version: meson.project_version(),
         name: 'libdcs-control',
     filebase: 'libdcs-control-@0@'.format(libdcs_api_version),
  description: 'API for OpenDCS feedback controller classes',
     requires: [ 'libpeas-1.0', 'libzmq' ],
  install_dir: join_paths(pkglibdir, 'pkgconfig'),
)
