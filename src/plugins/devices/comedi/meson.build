if get_option('with-device-comedi')

comedi_device_sources = [
  'comedi-device.vala',
]

comedi_device_deps = plugin_deps

comedi_device_c_args = [
  '-DG_LOG_DOMAIN="comedi-device"',
  '-DPACKAGE_DATADIR="@0@"'.format(join_paths(get_option('prefix'),
                                              get_option('datadir'),
                                              'dcs'))
]

configure_file(
          input: 'comedi.plugin',
         output: 'comedi.plugin',
  configuration: configuration_data(),
        install: true,
    install_dir: dir_device,
)

configure_file(
          input: 'comedi.json',
         output: 'comedi.json',
  configuration: configuration_data(),
        install: true,
    install_dir: dir_deviceconf,
)

shared_module('comedi-device', comedi_device_sources,
  dependencies: comedi_device_deps,
        c_args: comedi_device_c_args,
     link_args: plugin_link_args,
  link_depends: plugin_link_deps,
       install: true,
   install_dir: dir_device,
)

endif
