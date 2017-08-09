libdcs_sources = libdcs_generated_headers + [
  'dcs-abstract-buildable.vala',
  'dcs-abstract-config.vala',
  'dcs-abstract-container.vala',
  'dcs-abstract-object.vala',
  'dcs-application.vala',
  'dcs-buildable.vala',
  'dcs-cld-adapter.vala',
  'dcs-config-file.vala',
  'dcs-config-node.vala',
  'dcs-config-provider.vala',
  'dcs-config-util.vala',
  'dcs-config.vala',
  'dcs-container.vala',
  'dcs-controller.vala',
  'dcs-dataseries.vala',
  'dcs-dbus-interface.vala',
  'dcs-edge.vala',
  'dcs-extendable.vala',
  'dcs-factory-provider.vala',
  'dcs-factory.vala',
  'dcs-graph.vala',
  'dcs-legacy-config.vala',
  'dcs-legacy-plugin.vala',
  'dcs-log.vala',
  'dcs-message.vala',
  'dcs-meta-config.vala',
  'dcs-meta-factory.vala',
  'dcs-model.vala',
  'dcs-module-loader.vala',
  'dcs-node.vala',
  'dcs-object.vala',
  'dcs-plugin-extension.vala',
  'dcs-plugin-factory.vala',
  'dcs-plugin-information.vala',
  'dcs-plugin-loader.vala',
  'dcs-plugin-manager.vala',
  'dcs-plugin.vala',
  'dcs-point.vala',
  'dcs-ref-container.vala',
  'dcs-ref-linker.vala',
  'dcs-runnable.vala',
  'dcs-serializable.vala',
  'dcs-view.vala',
]

libdcs = shared_library('dcs-' + libdcs_api_version, libdcs_sources,
  link_depends: 'dcs.map',
     link_args: [ '-Wl,--version-script,' + join_paths(meson.current_source_dir(), 'dcs.map') ],
   vala_header: 'dcs.h',
     vala_args: common_vala_args,
     vala_vapi: 'dcs-@0@.vapi'.format(libdcs_api_version),
      vala_gir: 'Dcs-@0@.gir'.format(libdcs_api_version),
  dependencies: libdcs_deps,
        c_args: libdcs_args,
     soversion: soversion,
       install: true,
   install_dir: [ true, true, true, true ],
)

if g_ir_compiler.found()
  custom_target('DcsCore-@0@.typelib'.format(libdcs_api_version),
        command: [ g_ir_compiler,
                   '--shared-library', libdcs.full_path(),
                   '--output', '@OUTPUT@',
                   #'@INPUT@',
                   join_paths(meson.current_build_dir(), 'DcsCore-@0@.gir'.format(libdcs_api_version)),
                 ],
          #input: join_paths(meson.current_build_dir(), 'DcsCore-@0@.gir'.format(libdcs_api_version)),
         output: 'DcsCore-@0@.typelib'.format(libdcs_api_version),
        depends: libdcs,
        install: true,
    install_dir: dir_typelib,
  )
endif

custom_target('DcsCore-@0@.gir'.format(libdcs_api_version),
      command: [ sed,
                 '-e', 's,Dcs[.],DcsCore.,g',
                 '-e', 's,namespace name="Dcs",namespace name="DcsCore",g',
                 #'@INPUT@',
                 join_paths(meson.current_build_dir(), 'Dcs-@0@.gir'.format(libdcs_api_version)),
               ],
        #input: join_paths(meson.current_build_dir(), 'Dcs-@0@.gir'.format(libdcs_api_version)),
       output: 'DcsCore-@0@.gir'.format(libdcs_api_version),
      capture: true,
      install: true,
  install_dir: dir_gir,
)

libdcs_girdir = meson.current_build_dir()

# XXX not sure if deps were done correctly here
libdcs_dep = declare_dependency(
              sources: libdcs_generated_headers,
         dependencies: libdcs_deps,
            link_with: libdcs,
  include_directories: include_directories('.'),
)

# Doesn't link to libdcs
libdcs_plugin_dep = declare_dependency(
              sources: libdcs_generated_headers,
         dependencies: libdcs_deps,
  include_directories: include_directories('.'),
)

pkgg = import('pkgconfig')

pkgg.generate(
    libraries: [libdcs],
      subdirs: [ 'dcs-@0@'.format(meson.project_version()) ],
      version: meson.project_version(),
         name: 'libdcs',
     filebase: 'libdcs-@0@'.format(libdcs_api_version),
  description: 'Core objects for OpenDCS',
     requires: [ 'gee-0.8' ],
  install_dir: join_paths(pkglibdir, 'pkgconfig'),
)
