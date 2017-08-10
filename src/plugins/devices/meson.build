device_deps = [
  libdcs_daq_plugin_dep,
]

subdir('arduino')
subdir('comedi')
subdir('mccusb')
subdir('signal-generator')

status += [
  'Devices:',
  '',
  'Arduino ............................... : @0@'.format(get_option('with-device-arduino')),
  'Comedi ................................ : @0@'.format(get_option('with-device-comedi')),
  'Measurement Computing USB ............. : @0@'.format(get_option('with-device-mccusb')),
  'Signal Generator ...................... : @0@'.format(get_option('with-device-signal-generator')),
  '', ''
]
