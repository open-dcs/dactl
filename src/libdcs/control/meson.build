control_headers = []

control_sources = [
  'dcs-control-controller.vala',
  'dcs-control-factory.vala',
  'dcs-control-loop-manager.vala',
]

libdcs_headers += files(control_headers)
libdcs_sources += files(control_sources)

install_headers(control_headers, subdir: join_paths(libdcs_header_subdir, 'control'))
