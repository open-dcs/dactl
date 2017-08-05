if get_option('with_device_comedi')

comedi_device_sources = [
  'comedi-device.vala',
]

comedi_device_deps = device_deps

comedi_device_c_args = [
  '-DLOG_DOMAIN="comedi-device"',
  '-DGETTEXT_PACKAGE="opendcs"',
  '-DPACKAGE_DATADIR="@0@"'.format(join_paths(get_option('prefix'),
                                              get_option('datadir'),
                                              'dcs'))
]

configure_file(
          input: 'comedi.plugin',
         output: 'comedi.plugin',
  configuration: configuration_data(),
        install: true,
    install_dir: devicedir,
)

configure_file(
          input: 'comedi.json',
         output: 'comedi.json',
  configuration: configuration_data(),
        install: true,
    install_dir: deviceconfdir,
)

shared_module('comedi-device', comedi_device_sources,
  dependencies: comedi_device_deps,
        c_args: comedi_device_c_args,
     link_args: plugin_link_args,
  link_depends: plugin_link_deps,
       install: true,
   install_dir: devicedir,
)

endif
