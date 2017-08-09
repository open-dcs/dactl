if get_option('with_ui')

configure_file(
  input: 'dcs.xml',
  output: 'dcs.xml',
  configuration: configuration_data(),
  install: true,
  install_dir: join_paths(get_option('datadir'), 'glade', 'catalogs'),
)

configure_file(
  input: 'dcsui.xml',
  output: 'dcsui.xml',
  configuration: configuration_data(),
  install: true,
  install_dir: join_paths(get_option('datadir'), 'glade', 'catalogs'),
)

endif
