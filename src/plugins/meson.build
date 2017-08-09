plugin_link_deps = join_paths(meson.current_source_dir(), 'plugins.map')
plugin_link_args = [ '-Wl,--version-script,' + plugin_link_deps ]

plugin_vala_args = [
  #'--vapidir', join_paths(meson.build_root(), 'src/lib/core'),
  '--vapidir', join_paths(meson.build_root(), 'src/lib/net'),
  #'--pkg', 'dcs-@0@'.format(libdcs_api_version),
  '--pkg', 'dcs-net-@0@'.format(libdcs_api_version),
]
