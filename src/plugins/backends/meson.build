backend_deps = common_deps + [
  libdcs_plugin_dep,
  libdcs_net_plugin_dep,
  #libdcs_log_plugin_dep,
]

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
