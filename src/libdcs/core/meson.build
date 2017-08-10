libdcs_core_sources = [
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

libdcs_core_girdir = meson.current_build_dir()

libdcs_core_c_args = common_c_args + [
  '-DG_LOG_DOMAIN="DcsCore"',
]

libdcs_core_vala_args = common_vala_args + []

libdcs_core_deps = common_deps + [
  libgmodule_dep,
  link_libconfig,
]

libdcs_core = library('dcs-core-' + libdcs_api_version, libdcs_core_sources + libdcs_generated_headers,
  link_depends: 'dcs-core.map',
     link_args: [ '-Wl,--version-script,' + join_paths(meson.current_source_dir(), 'dcs-core.map') ],
   vala_header: 'dcs-core.h',
     vala_args: libdcs_core_vala_args,
     vala_vapi: 'dcs-core-@0@.vapi'.format(libdcs_api_version),
      vala_gir: 'Dcs-@0@.gir'.format(libdcs_api_version),
  dependencies: libdcs_core_deps,
        c_args: libdcs_core_c_args,
     soversion: soversion,
       install: true,
   install_dir: [ true, true, true, false ],
)

libdcs_core_girdir = meson.current_build_dir()

# XXX not sure if deps were done correctly here
libdcs_core_dep = declare_dependency(
              sources: libdcs_generated_headers,
         dependencies: libdcs_core_deps,
            link_with: libdcs_core,
  include_directories: include_directories('.'),
)

# Doesn't link to libdcs
libdcs_core_plugin_dep = declare_dependency(
              sources: libdcs_generated_headers,
         dependencies: libdcs_core_deps,
  include_directories: include_directories('.'),
)

pkgg = import('pkgconfig')

pkgg.generate(
    libraries: [libdcs_core],
      subdirs: [ 'dcs-core-@0@'.format(meson.project_version()) ],
      version: meson.project_version(),
         name: 'libdcs-core',
     filebase: 'libdcs-core-@0@'.format(libdcs_api_version),
  description: 'Core objects for OpenDCS',
     requires: [ 'gee-0.8', 'gio-2.0' ],
  install_dir: join_paths(pkglibdir, 'pkgconfig'),
)
