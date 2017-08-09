libdcs_cli_generated_headers = []

libdcs_cli_sources = [
  'dcs-cli-application.vala',
  'dcs-cli-factory.vala',
]

libdcs_cli_deps = [
  libdcs_dep,
]

libdcs_cli = shared_library('dcs-cli-' + libdcs_api_version, libdcs_cli_sources,
  link_depends: 'dcs-cli.map',
     link_args: [ '-Wl,--version-script,' + join_paths(meson.current_source_dir(), 'dcs-cli.map') ],
   vala_header: 'dcs-cli.h',
     vala_vapi: 'dcs-cli-@0@.vapi'.format(libdcs_api_version),
      vala_gir: 'Dcs-@0@.gir'.format(libdcs_api_version),
  dependencies: libdcs_cli_deps,
        c_args: libdcs_args,
     soversion: soversion,
       install: true,
   install_dir: [ true, true, true, true ],
)

if g_ir_compiler.found()
  custom_target('DcsCLI-@0@.typelib'.format(libdcs_api_version),
        command: [ g_ir_compiler,
                   '--shared-library', libdcs_cli.full_path(),
                   '--includedir', libdcs_girdir,
                   '--output', '@OUTPUT@',
                   #'@INPUT@',
                   join_paths(meson.current_build_dir(), 'DcsCLI-@0@.gir'.format(libdcs_api_version)),
                 ],
          #input: join_paths(meson.current_build_dir(), 'DcsCLI-@0@.gir'.format(libdcs_api_version)),
         output: 'DcsCLI-@0@.typelib'.format(libdcs_api_version),
        depends: libdcs_cli,
        install: true,
    install_dir: dir_typelib,
)
endif

custom_target('DcsCLI-@0@.gir'.format(libdcs_api_version),
      command: [ sed,
                 '-e', 's|Dcs[.]|DcsCLI.|g',
                 '-e', 's|namespace name="Dcs"|namespace name="DcsCLI"|g',
                 '-e', 's|<package name="dcs-cli-@0@"/>|<include name="DcsCore" version="@0@"/><package name="dcs-cli-@0@"/>|'.format(libdcs_api_version),
                 #'@INPUT@',
                 join_paths(meson.current_build_dir(), 'Dcs-@0@.gir'.format(libdcs_api_version)),
               ],
        #input: join_paths(meson.current_build_dir(), 'Dcs-@0@.gir'.format(libdcs_api_version)),
       output: 'DcsCLI-@0@.gir'.format(libdcs_api_version),
      capture: true,
      install: true,
  install_dir: dir_gir,
)

libdcs_cli_girdir = meson.current_build_dir()

# XXX not sure if deps were done correctly here
libdcs_cli_dep = declare_dependency(
              sources: libdcs_cli_generated_headers,
         dependencies: libdcs_cli_deps,
            link_with: libdcs_cli,
  include_directories: include_directories('.'),
)

# Doesn't link to libdcs_cli
libdcs_cli_plugin_dep = declare_dependency(
              sources: libdcs_cli_generated_headers,
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
