if get_option('with-device-mccusb')

mccusb_device_sources = [
  'mccusb-device.vala',
]

mccusb_device_deps = device_deps

mccusb_device_c_args = [
  '-DG_LOG_DOMAIN="mccusb-device"',
  '-DPACKAGE_DATADIR="@0@"'.format(join_paths(get_option('prefix'),
                                              get_option('datadir'),
                                              'dcs'))
]

configure_file(
          input: 'mccusb.plugin',
         output: 'mccusb.plugin',
  configuration: configuration_data(),
        install: true,
    install_dir: devicedir,
)

configure_file(
          input: 'mccusb.json',
         output: 'mccusb.json',
  configuration: configuration_data(),
        install: true,
    install_dir: deviceconfdir,
)

shared_module('mccusb-device', mccusb_device_sources,
  dependencies: mccusb_device_deps,
        c_args: mccusb_device_c_args,
     link_args: plugin_link_args,
  link_depends: plugin_link_deps,
       install: true,
   install_dir: devicedir,
)

endif
