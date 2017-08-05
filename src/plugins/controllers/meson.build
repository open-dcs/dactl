controller_deps = common_deps + [
  libdcs_plugin_dep,
  libdcs_net_plugin_dep,
  #libdcs_control_plugin_dep,
]

controllerdir = join_paths(get_option('prefix'), get_option('libdir'), 'dcs/controllers')
controllerdatadir = join_paths(get_option('prefix'), get_option('datadir'), 'dcs/controller')
controllerconfdir = join_paths(get_option('prefix'), get_option('sysconfdir'), 'dcs/controller')

conf.set_quoted('CONTROLLER_DIR', controllerdir)
conf.set_quoted('CONTROLLER_CONF_DIR', controllerdatadir)
conf.set_quoted('CONTROLLER_DATA_DIR', controllerconfdir)

subdir('pid')

status += [
  'Controllers:',
  '',
  'PID ................................... : @0@'.format(get_option('with_controller_pid')),
  '', ''
]
