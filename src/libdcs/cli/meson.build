cli_headers = []

cli_sources = [
  'dcs-cli-application.vala',
  'dcs-cli-factory.vala',
]

libdcs_headers += files(cli_headers)
libdcs_sources += files(cli_sources)

install_headers(cli_headers, subdir: join_paths(libdcs_header_subdir, 'cli'))
