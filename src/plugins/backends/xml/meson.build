if get_option('with_backend_xml')

xml_backend_sources = [
  'xml-backend.vala',
  'dcs-xml-service-addin.vala',
]

xml_backend_deps = backend_deps

xml_backend_c_args = [
  '-DLOG_DOMAIN="xml-backend"',
  '-DGETTEXT_PACKAGE="opendcs"',
  '-DPACKAGE_DATADIR="@0@"'.format(join_paths(get_option('prefix'),
                                              get_option('datadir'),
                                              'dcs'))
]

configure_file(
          input: 'xml.plugin',
         output: 'xml.plugin',
  configuration: configuration_data(),
        install: true,
    install_dir: backenddir,
)

configure_file(
          input: 'xml.json',
         output: 'xml.json',
  configuration: configuration_data(),
        install: true,
    install_dir: backendconfdir,
)

shared_module('xml-backend', xml_backend_sources,
  dependencies: xml_backend_deps,
        c_args: xml_backend_c_args,
    #vala_args: plugin_vala_args,
     link_args: plugin_link_args,
  link_depends: plugin_link_deps,
       install: true,
   install_dir: backenddir,
)

endif
