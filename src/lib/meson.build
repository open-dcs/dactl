#libdcs_header_subdir = 'dcs-' + libdcs_api_version
libdcs_header_dir = pkgincludedir + '/libdcs'

version_data = configuration_data()
version_data.set('MAJOR_VERSION', MAJOR_VERSION)
version_data.set('MINOR_VERSION', MINOR_VERSION)
version_data.set('MICRO_VERSION', MICRO_VERSION)
version_data.set('VERSION', meson.project_version())

libdcs_api_version = '1.0'
soversion = 0

libdcs_version_h = configure_file(
          input: 'dcs-version.h.in',
         output: 'dcs-version.h',
  configuration: version_data,
        install: true,
    install_dir: libdcs_header_dir,
)

libdcs_conf = configuration_data()
libdcs_conf.set10('ENABLE_TRACING', get_option('enable_tracing'))
libdcs_conf.set('BUGREPORT_URL', 'https://github.com/open-dcs/dcs/issues')
libdcs_debug_h = configure_file(
          input: 'dcs-debug.h.in',
         output: 'dcs-debug.h',
  configuration: libdcs_conf,
        install: true,
    install_dir: libdcs_header_dir,
)

libdcs_generated_headers = [
  libdcs_debug_h,
  libdcs_version_h,
]

# TODO fix this, move into libconfig
libdcs_build_vapi = meson.get_compiler('vala').find_library('dcs-build', dirs: join_paths(meson.current_source_dir(), 'core'))
libdcs_build_dep = declare_dependency(dependencies: [libdcs_build_vapi])

# TODO remove this, it's only needed by the old plugin loader
libgmodule_dep = dependency('gmodule-2.0', version: '>= 2.50.0')

libdcs_args = []
libdcs_deps = common_deps + [
  libdcs_build_dep,
  libgmodule_dep,
]
