if get_option('with-backend-xml')

xml_backend_sources = [
  'xml-backend.vala',
  'dcs-xml-service-addin.vala',
]

xml_backend_deps = plugin_deps

xml_backend_c_args = [
  '-DG_LOG_DOMAIN="xml-backend"',
  '-DPACKAGE_DATADIR="@0@"'.format(join_paths(get_option('prefix'),
                                              get_option('datadir'),
                                              'dcs'))
]

configure_file(
          input: 'xml.plugin',
         output: 'xml.plugin',
  configuration: configuration_data(),
        install: true,
    install_dir: dir_backend,
)

configure_file(
          input: 'xml.json',
         output: 'xml.json',
  configuration: configuration_data(),
        install: true,
    install_dir: dir_backendconf,
)

shared_module('xml-backend', xml_backend_sources,
  dependencies: xml_backend_deps,
        c_args: xml_backend_c_args,
     link_args: plugin_link_args,
  link_depends: plugin_link_deps,
       install: true,
   install_dir: dir_backend,
)

endif
