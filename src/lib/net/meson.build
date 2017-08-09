libdcs_net_generated_headers = []

libdcs_net_sources = libdcs_net_generated_headers + [
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

libdcs_net_deps = [
  libdcs_dep,
]

libdcs_net_vala_args = common_vala_args + []

libdcs_net = shared_library('dcs-net-' + libdcs_api_version, libdcs_net_sources,
  link_depends: 'dcs-net.map',
     link_args: [ '-Wl,--version-script,' + join_paths(meson.current_source_dir(), 'dcs-net.map') ],
   vala_header: 'dcs-net.h',
     vala_args: libdcs_net_vala_args,
     vala_vapi: 'dcs-net-@0@.vapi'.format(libdcs_api_version),
      vala_gir: 'Dcs-@0@.gir'.format(libdcs_api_version),
  dependencies: libdcs_net_deps,
        c_args: libdcs_args,
     soversion: soversion,
       install: true,
   install_dir: [ true, true, true, true ],
)

if g_ir_compiler.found()
  custom_target('DcsNet-@0@.typelib'.format(libdcs_api_version),
        command: [ g_ir_compiler,
                   '--shared-library', libdcs_net.full_path(),
                   '--includedir', libdcs_girdir,
                   '--output', '@OUTPUT@',
                   #'@INPUT@',
                   join_paths(meson.current_build_dir(), 'DcsNet-@0@.gir'.format(libdcs_api_version)),
                 ],
          #input: join_paths(meson.current_build_dir(), 'DcsNet-@0@.gir'.format(libdcs_api_version)),
         output: 'DcsNet-@0@.typelib'.format(libdcs_api_version),
        depends: libdcs_net,
        install: true,
    install_dir: dir_typelib,
)
endif

custom_target('DcsNet-@0@.gir'.format(libdcs_api_version),
      command: [ sed,
                 '-e', 's|Dcs[.]|DcsNet.|g',
                 '-e', 's|namespace name="Dcs"|namespace name="DcsNet"|g',
                 '-e', 's|DcsNet[.]Node|DcsCore.Node|g',
                 '-e', 's|DcsNet[.]FooApplication|DcsCore.FooApplication|g',
                 '-e', 's|<package name="dcs-net-@0@"/>|<include name="DcsCore" version="@0@"/><package name="dcs-net-@0@"/>|'.format(libdcs_api_version),
                 #'@INPUT@',
                 join_paths(meson.current_build_dir(), 'Dcs-@0@.gir'.format(libdcs_api_version)),
               ],
        #input: join_paths(meson.current_build_dir(), 'Dcs-@0@.gir'.format(libdcs_api_version)),
       output: 'DcsNet-@0@.gir'.format(libdcs_api_version),
      capture: true,
      install: true,
  install_dir: dir_gir,
)

libdcs_net_girdir = meson.current_build_dir()

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
