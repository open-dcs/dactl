libdcs_header_subdir = join_paths('dcs', 'libdcs')
libdcs_header_dir = pkgincludedir + '/libdcs'

libdcs_api_version = '1.0'

libdcs_generated_headers = []
libdcs_headers = []
libdcs_sources = []
libdcs_vala_args = [
  '--vapidir', dir_libconfig,
  '--pkg', 'dcs-config',
]

version_data = configuration_data()
version_data.set('MAJOR_VERSION', MAJOR_VERSION)
version_data.set('MINOR_VERSION', MINOR_VERSION)
version_data.set('MICRO_VERSION', MICRO_VERSION)
version_data.set('VERSION', meson.project_version())

libdcs_version_h = configure_file(
          input: 'dcs-version.h.in',
         output: 'dcs-version.h',
  configuration: version_data,
        install: true,
    install_dir: libdcs_header_subdir,
)

libdcs_generated_headers += [ libdcs_version_h ]

# TODO remove this, it's only needed by the old plugin loader
dep_gmodule = dependency('gmodule-2.0', version: '>= 2.50.0')

libdcs_deps = [
  dep_gio,
  dep_gee,
  dep_gsl,
  dep_gmodule,
  dep_peas,
  dep_json,
  dep_xml,
  dep_cld,
  dep_zmq,
  dep_soup,
  dep_comedi,
  dep_posix,
  dep_linux,
]

libdcs_deps += link_libconfig

subdir('core')
subdir('cli')
subdir('net')
subdir('control')
subdir('daq')
subdir('log')
subdir('ui')

libdcs_conf = configuration_data()
libdcs_conf.set10('ENABLE_TRACING', get_option('enable-tracing'))
libdcs_conf.set('BUGREPORT_URL', 'https://github.com/open-dcs/dcs/issues')
libdcs_debug_h = configure_file(
          input: 'dcs-debug.h.in',
         output: 'dcs-debug.h',
  configuration: libdcs_conf,
        install: true,
    install_dir: libdcs_header_dir,
)

libdcs_generated_headers += [ libdcs_debug_h ]

libdcs_link_args = [ '-Wl,--version-script,' + join_paths(meson.current_source_dir(), 'dcs.map') ]

libdcs_reqs = [
  'cld-1.0',
  'gee-0.8',
  'glib-2.0',
  'gsl',
  'json-glib-1.0',
  'libpeas-1.0',
  'libsoup-2.4',
  'libxml-2.0',
  'libzmq',
]

deps_conf = configuration_data()

configure_file(
          input: 'libdcs.deps.in',
         output: 'libdcs-@0@.deps'.format(libdcs_api_version),
  configuration: deps_conf,
        install: true,
    install_dir: pkgvapidir,
)

libdcs = shared_library('dcs-' + libdcs_api_version, libdcs_sources,
   dependencies: libdcs_deps,
   link_depends: 'dcs.map',
      vala_args: libdcs_vala_args,
      link_args: libdcs_link_args,
        install: true,
    install_dir: pkglibdir,
  install_rpath: pkglibdir_abs,
)

libdcs_dep = declare_dependency(
              sources: libdcs_generated_headers,
         dependencies: libdcs_deps,
            link_with: libdcs,
  include_directories: include_directories('.'),
)

# Doesn't link to libdcs
libdcs_plugin_dep = declare_dependency(
              sources: libdcs_generated_headers,
  include_directories: include_directories('.'),
         dependencies: libdcs_deps,
)

pkgg = import('pkgconfig')

pkgg.generate(
    libraries: [libdcs],
      subdirs: [ 'dcs-@0@/libdcs'.format(meson.project_version()) ],
      version: meson.project_version(),
         name: 'libdcs',
     filebase: 'libdcs-1.0',
  description: 'libdcs contains...',
     requires: libdcs_reqs,
  install_dir: join_paths(pkglibdir, 'pkgconfig'),
)
