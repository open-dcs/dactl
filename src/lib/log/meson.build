libdcs_log_generated_headers = []

libdcs_log_sources = [
  'dcs-log-backend-manager.vala',
  'dcs-log-backend.vala',
  'dcs-log-column.vala',
  'dcs-log-factory.vala',
  'dcs-log-file.vala',
  'dcs-log-query.vala',
]

libdcs_log_deps = [
  libdcs_net_dep,
]

libdcs_log_vala_args = [
  '--vapidir', join_paths(meson.build_root(), 'src/lib/core'),
  '--vapidir', join_paths(meson.build_root(), 'src/lib/net'),
  #'--pkg', 'dcs-net-@0@'.format(libdcs_api_version),
]

libdcs_log = shared_library('dcs-log-' + libdcs_api_version, libdcs_log_sources,
  link_depends: 'dcs-log.map',
     link_args: [ '-Wl,--version-script,' + join_paths(meson.current_source_dir(), 'dcs-log.map') ],
   vala_header: 'dcs-log.h',
     vala_args: libdcs_log_vala_args,
     vala_vapi: 'dcs-log-@0@.vapi'.format(libdcs_api_version),
      vala_gir: 'Dcs-@0@.gir'.format(libdcs_api_version),
  dependencies: libdcs_log_deps,
        c_args: libdcs_args,
     soversion: soversion,
       install: true,
   install_dir: [ true, true, true, true ],
)

if g_ir_compiler.found()
  custom_target('DcsLog-@0@.typelib'.format(libdcs_api_version),
        command: [ g_ir_compiler,
                   '--shared-library', libdcs_log.full_path(),
                   '--includedir', libdcs_girdir,
                   '--output', '@OUTPUT@',
                   #'@INPUT@',
                   join_paths(meson.current_build_dir(), 'DcsLog-@0@.gir'.format(libdcs_api_version)),
                 ],
          #input: join_paths(meson.current_build_dir(), 'DcsLog-@0@.gir'.format(libdcs_api_version)),
         output: 'DcsLog-@0@.typelib'.format(libdcs_api_version),
        depends: libdcs_log,
        install: true,
    install_dir: dir_typelib,
)
endif

custom_target('DcsLog-@0@.gir'.format(libdcs_api_version),
      command: [ sed,
                 '-e', 's|Dcs[.]|DcsLog.|g',
                 '-e', 's|namespace name="Dcs"|namespace name="DcsLog"|g',
                 '-e', 's|DcsLog[.]Node|DcsCore.Node|g',
                 '-e', 's|DcsLog[.]PluginExtension|DcsCore.PluginExtension|g',
                 '-e', 's|<package name="dcs-log-@0@"/>|<include name="DcsCore" version="@0@"/><package name="dcs-log-@0@"/>|'.format(libdcs_api_version),
                 #'@INPUT@',
                 join_paths(meson.current_build_dir(), 'Dcs-@0@.gir'.format(libdcs_api_version)),
               ],
        #input: join_paths(meson.current_build_dir(), 'Dcs-@0@.gir'.format(libdcs_api_version)),
       output: 'DcsLog-@0@.gir'.format(libdcs_api_version),
      capture: true,
      install: true,
  install_dir: dir_gir,
)

libdcs_log_girdir = meson.current_build_dir()

# XXX not sure if deps were done correctly here
libdcs_log_dep = declare_dependency(
              sources: libdcs_log_generated_headers,
         dependencies: libdcs_log_deps,
            link_with: libdcs_log,
  include_directories: include_directories('.'),
)

# Doesn't link to libdcs_log
libdcs_log_plugin_dep = declare_dependency(
              sources: libdcs_log_generated_headers,
         dependencies: libdcs_log_deps,
  include_directories: include_directories('.'),
)

pkgg = import('pkgconfig')

pkgg.generate(
    libraries: [libdcs_log],
      subdirs: [ 'dcs-@0@'.format(meson.project_version()) ],
      version: meson.project_version(),
         name: 'libdcs-log',
     filebase: 'libdcs-log-@0@'.format(libdcs_api_version),
  description: 'API for OpenDCS data logging classes',
     requires: [ 'gio-2.0', 'gee-0.8', 'json-glib-1.0' ],
  install_dir: join_paths(pkglibdir, 'pkgconfig'),
)
