libdcs_cli_sources = [
  'dcs-cli-application.vala',
  'dcs-cli-factory.vala',
]

libdcs_cli_vala_args = common_vala_args + []

libdcs_cli_c_args = common_c_args + [
  '-DG_LOG_DOMAIN="DcsCLI"',
]

libdcs_cli_deps = [
  libdcs_core_dep,
]

libdcs_cli = library('dcs-cli-' + libdcs_api_version, libdcs_cli_sources + libdcs_generated_headers,
  link_depends: 'dcs-cli.map',
     link_args: [ '-Wl,--version-script,' + join_paths(meson.current_source_dir(), 'dcs-cli.map') ],
   vala_header: 'dcs-cli.h',
     vala_args: libdcs_cli_vala_args,
     vala_vapi: 'dcs-cli-@0@.vapi'.format(libdcs_api_version),
      vala_gir: 'Dcs-@0@.gir'.format(libdcs_api_version),
  dependencies: libdcs_cli_deps,
        c_args: libdcs_cli_c_args,
     soversion: soversion,
       install: true,
   install_dir: [ true, true, true, false ],
)

libdcs_cli_girdir = meson.current_build_dir()

# XXX not sure if deps were done correctly here
libdcs_cli_dep = declare_dependency(
              sources: libdcs_generated_headers,
         dependencies: libdcs_cli_deps,
            link_with: libdcs_cli,
  include_directories: include_directories('.'),
)

# Doesn't link to libdcs_cli
libdcs_cli_plugin_dep = declare_dependency(
              sources: libdcs_generated_headers,
         dependencies: libdcs_cli_deps,
  include_directories: include_directories('.'),
)

pkgg = import('pkgconfig')

pkgg.generate(
    libraries: [libdcs_cli],
      subdirs: [ 'dcs-@0@'.format(meson.project_version()) ],
      version: meson.project_version(),
         name: 'libdcs-cli',
     filebase: 'libdcs-cli-@0@'.format(libdcs_api_version),
  description: 'Classes for creating OpenDCS services and command line programs',
     requires: [ 'gio-2.0', 'libpeas-1.0' ],
  install_dir: join_paths(pkglibdir, 'pkgconfig'),
)
