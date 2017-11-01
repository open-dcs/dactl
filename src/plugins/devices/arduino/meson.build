if get_option('with-device-arduino')

arduino_device_sources = [
  'arduino-device.vala',
  'dcs-arduino-config-provider.vala',
  'dcs-arduino-factory-provider.vala',
  'dcs-arduino-service-addin.vala',
]

arduino_device_deps = plugin_deps

arduino_device_c_args = [
  '-DG_LOG_DOMAIN="arduino-device"',
  '-DPACKAGE_DATADIR="@0@"'.format(join_paths(get_option('prefix'),
                                              get_option('datadir'),
                                              'dcs'))
]

configure_file(
          input: 'arduino.plugin',
         output: 'arduino.plugin',
  configuration: configuration_data(),
        install: true,
    install_dir: dir_device,
)

configure_file(
          input: 'arduino.json',
         output: 'arduino.json',
  configuration: configuration_data(),
        install: true,
    install_dir: dir_deviceconf,
)

shared_module('arduino-device', arduino_device_sources,
  dependencies: arduino_device_deps,
        c_args: arduino_device_c_args,
     link_args: plugin_link_args,
  link_depends: plugin_link_deps,
       install: true,
   install_dir: dir_device,
)

endif
