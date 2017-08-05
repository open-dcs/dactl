if get_option('with_device_arduino')

arduino_device_sources = [
  'arduino-device.vala',
  'dcs-arduino-config-provider.vala',
  'dcs-arduino-factory-provider.vala',
  'dcs-arduino-service-addin.vala',
]

arduino_device_deps = device_deps

arduino_device_c_args = [
  '-DLOG_DOMAIN="arduino-device"',
  '-DGETTEXT_PACKAGE="opendcs"',
  '-DPACKAGE_DATADIR="@0@"'.format(join_paths(get_option('prefix'),
                                              get_option('datadir'),
                                              'dcs'))
]

configure_file(
          input: 'arduino.plugin',
         output: 'arduino.plugin',
  configuration: configuration_data(),
        install: true,
    install_dir: devicedir,
)

configure_file(
          input: 'arduino.json',
         output: 'arduino.json',
  configuration: configuration_data(),
        install: true,
    install_dir: deviceconfdir,
)

shared_module('arduino-device', arduino_device_sources,
  dependencies: arduino_device_deps,
        c_args: arduino_device_c_args,
     link_args: plugin_link_args,
  link_depends: plugin_link_deps,
       install: true,
   install_dir: devicedir,
)

endif
