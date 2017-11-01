if get_option('with-valadoc')

valadoc = find_program('valadoc')
valac_api_version = run_command('valac', '--api-version')
driver = '--driver=@0@'.format(valac_api_version.stdout().strip())
pkgname = '--package-name=Dcs-@0@'.format(libdcs_api_version)
pkgversion = '--package-version=@0@'.format(meson.project_version())
dir_output = 'Dcs-@0@'.format(libdcs_api_version)
dir_devhelp = join_paths(get_option ('datadir'), 'devhelp','books')

api_vala_args = [
  '--vapidir', join_paths(meson.source_root(), 'src/lib/core'),
  '--vapidir', join_paths(meson.source_root(), 'vapi'),
  '--pkg', 'gee-0.8',
  '--pkg', 'gio-2.0',
  '--pkg', 'gmodule-2.0',
  '--pkg', 'json-glib-1.0',
  '--pkg', 'libxml-2.0',
  '--pkg', 'libpeas-1.0',
  '--pkg', 'libsoup-2.4',
  '--pkg', 'libzmq',
  '--pkg', 'cld-1.0',
  '--pkg', 'comedi',
]

api_sources = []
api_sources += libdcs_sources
#api_sources += libdcs_cli_sources
#api_sources += libdcs_control_sources
#api_sources += libdcs_daq_sources
#api_sources += libdcs_log_sources
api_sources += libdcs_net_sources

if get_option('with_ui')
  api_vala_args += [
    '--pkg', 'cairo',
    '--pkg', 'gsl',
    '--pkg', 'gtk+-3.0',
    '--pkg', 'gtksourceview-3.0',
    '--pkg', 'librsvg-2.0',
    '--pkg', 'pango',
    '--pkg', 'webkit2gtk-4.0',
  ]

  api_sources += libdcs_ui_sources
endif

custom_target('valadocs',
        input: doc_sources,
       output: dir_output,
      command: [ valadoc,
                 driver,
                 '--doclet=devhelp',
                 '--force',
                 pkgname,
                 pkgversion,
                 api_vala_args,
                 '--directory', dir_output,
                 api_sources,
               ],
      install: true,
  install_dir: dir_devhelp,
)

endif
