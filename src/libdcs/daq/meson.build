daq_headers = []

daq_sources = [
  'dcs-daq-channel.vala',
  'dcs-daq-device-manager.vala',
  'dcs-daq-device.vala',
  'dcs-daq-factory.vala',
  'dcs-daq-port.vala',
  'dcs-daq-sensor.vala',
  'dcs-daq-serial-port.vala',
  'dcs-daq-signal.vala',
  'dcs-daq-task.vala',
]

libdcs_headers += files(daq_headers)
libdcs_sources += files(daq_sources)

install_headers(daq_headers, subdir: join_paths(libdcs_header_subdir, 'daq'))
