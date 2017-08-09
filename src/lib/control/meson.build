libdcs_control_generated_headers = []

libdcs_control_sources = [
  'dcs-control-controller.vala',
  'dcs-control-factory.vala',
  'dcs-control-loop-manager.vala',
]

libdcs_control_deps = [
  libdcs_net_dep,
]

libdcs_control_vala_args = [
  '--vapidir', join_paths(meson.build_root(), 'src/lib/core'),
  '--vapidir', join_paths(meson.build_root(), 'src/lib/net'),
  #'--pkg', 'dcs-net-@0@'.format(libdcs_api_version),
]

libdcs_control = shared_library('dcs-control-' + libdcs_api_version, libdcs_control_sources,
  link_depends: 'dcs-control.map',
     link_args: [ '-Wl,--version-script,' + join_paths(meson.current_source_dir(), 'dcs-control.map') ],
   vala_header: 'dcs-control.h',
     vala_args: libdcs_control_vala_args,
     vala_vapi: 'dcs-control-@0@.vapi'.format(libdcs_api_version),
      vala_gir: 'Dcs-@0@.gir'.format(libdcs_api_version),
  dependencies: libdcs_control_deps,
        c_args: libdcs_args,
     soversion: soversion,
       install: true,
   install_dir: [ true, true, true, true ],
)

if g_ir_compiler.found()
  custom_target('DcsControl-@0@.typelib'.format(libdcs_api_version),
        command: [ g_ir_compiler,
                   '--shared-library', libdcs_control.full_path(),
                   '--includedir', libdcs_girdir,
                   '--output', '@OUTPUT@',
                   #'@INPUT@',
                   join_paths(meson.current_build_dir(), 'DcsControl-@0@.gir'.format(libdcs_api_version)),
                 ],
          #input: join_paths(meson.current_build_dir(), 'DcsControl-@0@.gir'.format(libdcs_api_version)),
         output: 'DcsControl-@0@.typelib'.format(libdcs_api_version),
        depends: libdcs_control,
        install: true,
    install_dir: dir_typelib,
)
endif

custom_target('DcsControl-@0@.gir'.format(libdcs_api_version),
      command: [ sed,
                 '-e', 's|Dcs[.]|DcsControl.|g',
                 '-e', 's|namespace name="Dcs"|namespace name="DcsControl"|g',
                 '-e', 's|DcsControl[.]Node|DcsCore.Node|g',
                 '-e', 's|DcsControl[.]PluginExtension|DcsCore.PluginExtension|g',
                 '-e', 's|<package name="dcs-control-@0@"/>|<include name="DcsCore" version="@0@"/><package name="dcs-control-@0@"/>|'.format(libdcs_api_version),
                 #'@INPUT@',
                 join_paths(meson.current_build_dir(), 'Dcs-@0@.gir'.format(libdcs_api_version)),
               ],
        #input: join_paths(meson.current_build_dir(), 'Dcs-@0@.gir'.format(libdcs_api_version)),
       output: 'DcsControl-@0@.gir'.format(libdcs_api_version),
      capture: true,
      install: true,
  install_dir: dir_gir,
)

libdcs_control_girdir = meson.current_build_dir()

# XXX not sure if deps were done correctly here
libdcs_control_dep = declare_dependency(
              sources: libdcs_control_generated_headers,
         dependencies: libdcs_control_deps,
            link_with: libdcs_control,
  include_directories: include_directories('.'),
)

# Doesn't link to libdcs_control
libdcs_control_plugin_dep = declare_dependency(
              sources: libdcs_control_generated_headers,
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
