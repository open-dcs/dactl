device_deps = common_deps + [
  libdcs_plugin_dep,
  libdcs_net_plugin_dep,
  #libdcs_daq_plugin_dep,
]

devicedir = join_paths(get_option('prefix'), get_option('libdir'), 'dcs/devices')
devicedatadir = join_paths(get_option('prefix'), get_option('datadir'), 'dcs/device')
deviceconfdir = join_paths(get_option('prefix'), get_option('sysconfdir'), 'dcs/device')

conf.set_quoted('DEVICE_DIR', devicedir)
conf.set_quoted('DEVICE_CONF_DIR', devicedatadir)
conf.set_quoted('DEVICE_DATA_DIR', deviceconfdir)

subdir('arduino')
subdir('comedi')
subdir('mccusb')
subdir('signal-generator')

status += [
  'Devices:',
  '',
  'Arduino ............................... : @0@'.format(get_option('with_device_arduino')),
  'Comedi ................................ : @0@'.format(get_option('with_device_comedi')),
  'Measurement Computing USB ............. : @0@'.format(get_option('with_device_mccusb')),
  'Signal Generator ...................... : @0@'.format(get_option('with_device_signal_generator')),
  '', ''
]
