if get_option('with-device-signal-generator')

configure_file(
          input: 'signal-generator.py',
         output: 'signal-generator.py',
  configuration: configuration_data(),
        install: true,
    install_dir: dir_device,
)

configure_file(
          input: 'signal-generator.plugin',
         output: 'signal-generator.plugin',
  configuration: configuration_data(),
        install: true,
    install_dir: dir_device,
)

configure_file(
          input: 'signal-generator.json',
         output: 'signal-generator.json',
  configuration: configuration_data(),
        install: true,
    install_dir: dir_deviceconf,
)

endif
