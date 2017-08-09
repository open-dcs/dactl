backend_deps = [
  libdcs_log_plugin_dep,
]

#backend_vala_args = plugin_vala_args + [
  #'--vapidir', join_paths(meson.build_root(), 'src/lib/log'),
  #'--pkg', 'dcs-log-@0@'.format(libdcs_api_version),
#]

backenddir = join_paths(get_option('prefix'), get_option('libdir'), 'dcs/backends')
backenddatadir = join_paths(get_option('prefix'), get_option('datadir'), 'dcs/backend')
backendconfdir = join_paths(get_option('prefix'), get_option('sysconfdir'), 'dcs/backend')

conf.set_quoted('BACKEND_DIR', backenddir)
conf.set_quoted('BACKEND_CONF_DIR', backenddatadir)
conf.set_quoted('BACKEND_DATA_DIR', backendconfdir)

subdir('xml')

status += [
  'Backends:',
  '',
  'XML ................................... : @0@'.format(get_option('with_backend_xml')),
  '', ''
]
