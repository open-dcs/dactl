log_headers = []

log_sources = [
  'dcs-log-backend-manager.vala',
  'dcs-log-backend.vala',
  'dcs-log-column.vala',
  'dcs-log-factory.vala',
  'dcs-log-file.vala',
  'dcs-log-query.vala',
]

libdcs_headers += files(log_headers)
libdcs_sources += files(log_sources)

install_headers(log_headers, subdir: join_paths(libdcs_header_subdir, 'log'))
