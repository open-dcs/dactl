if get_option('with-controller-pid')

pid_controller_sources = [
  'pid-controller.vala',
  'dcs-pid-service-addin.vala',
]

pid_controller_deps = plugin_deps

pid_controller_c_args = [
  '-DG_LOG_DOMAIN="pid-controller"',
  '-DPACKAGE_DATADIR="@0@"'.format(join_paths(get_option('prefix'),
                                              get_option('datadir'),
                                              'dcs'))
]

configure_file(
          input: 'pid.plugin',
         output: 'pid.plugin',
  configuration: configuration_data(),
        install: true,
    install_dir: dir_controller,
)

configure_file(
          input: 'pid.json',
         output: 'pid.json',
  configuration: configuration_data(),
        install: true,
    install_dir: dir_controllerconf,
)

shared_module('pid-controller', pid_controller_sources,
  dependencies: pid_controller_deps,
        c_args: pid_controller_c_args,
     link_args: plugin_link_args,
  link_depends: plugin_link_deps,
       install: true,
   install_dir: dir_controller,
)

endif
