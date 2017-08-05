libdcs_net_generated_headers = []

libdcs_net_sources = [
  'dcs-net-consumer.vala',
  'dcs-net-enum.vala',
  'dcs-net-factory.vala',
  'dcs-net-producer.vala',
  'dcs-net-publisher.vala',
  'dcs-net-replier.vala',
  'dcs-net-requester.vala',
  'dcs-net-router.vala',
  'dcs-net-service-provider.vala',
  'dcs-net-service.vala',
  'dcs-net-subscriber.vala',
  'dcs-net-zmq-client.vala',
  'dcs-net-zmq-service.vala',
]

libdcs_net_deps = common_deps + [
  libdcs_dep,
  libzmq_dep,
  libsoup_dep,
]

libdcs_net = shared_library('dcs-net-' + libdcs_api_version, libdcs_net_sources,
  link_depends: 'dcs-net.map',
     link_args: [ '-Wl,--version-script,' + join_paths(meson.current_source_dir(), 'dcs-net.map') ],
   vala_header: 'dcs-net.h',
     vala_vapi: 'dcs-net-@0@.vapi'.format(libdcs_api_version),
      vala_gir: 'DcsNet-@0@.gir'.format(libdcs_api_version),
  dependencies: libdcs_net_deps,
        c_args: libdcs_args,
     soversion: soversion,
       install: true,
   install_dir: [ true, true, true, true ],
)

g_ir_compiler = find_program('g-ir-compiler', required: false)
if g_ir_compiler.found()
  custom_target('DcsNet typelib',
        command: [ g_ir_compiler, '--shared-library', libdcs_net.full_path(), '--output', '@OUTPUT@', join_paths(meson.current_build_dir(), 'DcsNet-@0@.gir'.format(libdcs_api_version)) ],
          #input: join_paths(meson.current_build_dir(), 'DcsNet-@0@.gir'.format(libdcs_aip_version)),
         output: 'DcsNet-@0@.typelib'.format(libdcs_api_version),
        depends: libdcs_net,
        install: true,
    install_dir: join_paths(get_option('libdir'), 'girepository-1.0')
)
endif

# XXX not sure if deps were done correctly here
libdcs_net_dep = declare_dependency(
              sources: libdcs_net_generated_headers,
         dependencies: libdcs_net_deps,
            link_with: libdcs_net,
  include_directories: include_directories('.'),
)

# Doesn't link to libdcs_net
libdcs_net_plugin_dep = declare_dependency(
              sources: libdcs_net_generated_headers,
         dependencies: libdcs_net_deps,
  include_directories: include_directories('.'),
)

pkgg = import('pkgconfig')

pkgg.generate(
    libraries: [libdcs_net],
      subdirs: [ 'dcs-@0@'.format(meson.project_version()) ],
      version: meson.project_version(),
         name: 'libdcs-net',
     filebase: 'libdcs-net-@0@'.format(libdcs_api_version),
  description: 'Networking API for OpenDCS services and plugins',
     requires: [ 'libsoup-2.4', 'libzmq' ],
  install_dir: join_paths(pkglibdir, 'pkgconfig'),
)
