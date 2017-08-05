plugin_deps = common_deps + [
  libdcs_plugin_dep,
  libdcs_net_plugin_dep,
  libdcs_ui_plugin_dep,
]

plugindir = join_paths(get_option('prefix'), get_option('libdir'), 'dcs/plugins')
plugindatadir = join_paths(get_option('prefix'), get_option('datadir'), 'dcs/plugin')
pluginconfdir = join_paths(get_option('prefix'), get_option('sysconfdir'), 'dcs/plugin')

conf.set_quoted('PLUGIN_DIR', plugindir)
conf.set_quoted('PLUGIN_CONF_DIR', plugindatadir)
conf.set_quoted('PLUGIN_DATA_DIR', pluginconfdir)

#subdir('placeholder')

#status += [
  #'GUI Plugins:',
  #'',
  #'Placeholder ........................... : @0@'.format(get_option('with_plugin_placeholder')),
  #'', ''
#]
