controller_deps = [
  libdcs_control_plugin_dep,
]

#controller_vala_args = plugin_vala_args + [
  #'--vapidir', join_paths(meson.build_root(), 'src/lib/control'),
  #'--pkg', 'dcs-control-@0@'.format(libdcs_api_version),
#]

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
