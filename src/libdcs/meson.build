#libdcs_header_subdir = 'dcs-' + libdcs_api_version
libdcs_header_dir = pkgincludedir + '/libdcs'

version_data = configuration_data()
version_data.set('MAJOR_VERSION', MAJOR_VERSION)
version_data.set('MINOR_VERSION', MINOR_VERSION)
version_data.set('MICRO_VERSION', MICRO_VERSION)
version_data.set('VERSION', meson.project_version())

libdcs_api_version = '1.0'
soversion = 0

libdcs_version_h = configure_file(
          input: 'dcs-version.h.in',
         output: 'dcs-version.h',
  configuration: version_data,
        install: true,
    install_dir: libdcs_header_dir,
)

libdcs_conf = configuration_data()
libdcs_conf.set10('ENABLE_TRACING', get_option('enable-tracing'))
libdcs_conf.set('BUGREPORT_URL', 'https://github.com/open-dcs/dcs/issues')
libdcs_debug_h = configure_file(
          input: 'dcs-debug.h.in',
         output: 'dcs-debug.h',
  configuration: libdcs_conf,
        install: true,
    install_dir: libdcs_header_dir,
)

libdcs_generated_headers = [
  libdcs_debug_h,
  libdcs_version_h,
]

# TODO remove this, it's only needed by the old plugin loader
libgmodule_dep = dependency('gmodule-2.0', version: '>= 2.50.0')

subdir('core')
subdir('cli')
subdir('net')
subdir('control')
subdir('daq')
subdir('log')
subdir('ui')

# TODO figure out if this will ever work or if .gir/.typelib should just be built manually
# XXX commented out for now

#libdcs_core_generated_sources = []
#foreach file : libdcs_core_sources
  #tokens = file.split('.')
  #c_file = join_paths(meson.current_build_dir(), 'dcs-core-@0@@sha'.format(libdcs_api_version), '@0@.c'.format(tokens[0]))
  #libdcs_core_generated_sources += c_file
#endforeach

#libdcs_core_gir = gnome.generate_gir(libdcs_core,
              #sources: libdcs_core_generated_sources +
                       #libdcs_generated_headers +
                       #[ join_paths(meson.current_build_dir(), 'core', 'dcs-core.h') ],
            #nsversion: libdcs_api_version,
            #namespace: 'Dcs',
         #dependencies: [ libdcs_core_deps ],
        #symbol_prefix: 'dcs',
    #identifier_prefix: 'Dcs',
             #includes: [ 'Gio-2.0', 'Gee-0.8', 'Peas-1.0', 'Json-1.0', 'Cld-1.0' ],
              #install: true,
      #install_dir_gir: pkggirdir,
  #install_dir_typelib: pkgtypelibdir,
           #extra_args: [ '--c-include=core/dcs-core.h' ],
#)

#custom_target('DcsCore-@0@.gir'.format(libdcs_api_version),
      #command: [ sed,
                 #'-e', 's,Dcs[.],DcsCore.,g',
                 #'-e', 's,namespace name="Dcs",namespace name="DcsCore",g',
                 #'@INPUT@',
               #],
        #input: join_paths(meson.current_build_dir(), 'core', 'Dcs-@0@.gir'.format(libdcs_api_version)),
       #output: 'DcsCore-@0@.gir'.format(libdcs_api_version),
      #capture: true,
      #install: true,
  #install_dir: dir_gir,
#)

#custom_target('DcsCLI-@0@.gir'.format(libdcs_api_version),
      #command: [ sed,
                 #'-e', 's|Dcs[.]|DcsCLI.|g',
                 #'-e', 's|namespace name="Dcs"|namespace name="DcsCLI"|g',
                 #'-e', 's|<package name="dcs-cli-@0@"/>|<include name="DcsCore" version="@0@"/><package name="dcs-cli-@0@"/>|'.format(libdcs_api_version),
                 #'@INPUT@',
               #],
        #input: join_paths(meson.current_build_dir(), 'Dcs-@0@.gir'.format(libdcs_api_version)),
       #output: 'DcsCLI-@0@.gir'.format(libdcs_api_version),
      #capture: true,
      #install: true,
  #install_dir: dir_gir,
#)

#custom_target('DcsNet-@0@.gir'.format(libdcs_api_version),
      #command: [ sed,
                 #'-e', 's|Dcs[.]|DcsNet.|g',
                 #'-e', 's|namespace name="Dcs"|namespace name="DcsNet"|g',
                 #'-e', 's|DcsNet[.]Node|DcsCore.Node|g',
                 #'-e', 's|DcsNet[.]FooApplication|DcsCore.FooApplication|g',
                 #'-e', 's|<package name="dcs-net-@0@"/>|<include name="DcsCore" version="@0@"/><package name="dcs-net-@0@"/>|'.format(libdcs_api_version),
                 #'@INPUT@',
               #],
        #input: join_paths(meson.current_build_dir(), 'Dcs-@0@.gir'.format(libdcs_api_version)),
       #output: 'DcsNet-@0@.gir'.format(libdcs_api_version),
      #capture: true,
      #install: true,
  #install_dir: dir_gir,
#)

#custom_target('DcsControl-@0@.gir'.format(libdcs_api_version),
      #command: [ sed,
                 #'-e', 's|Dcs[.]|DcsControl.|g',
                 #'-e', 's|namespace name="Dcs"|namespace name="DcsControl"|g',
                 #'-e', 's|DcsControl[.]Node|DcsCore.Node|g',
                 #'-e', 's|DcsControl[.]PluginExtension|DcsCore.PluginExtension|g',
                 #'-e', 's|<package name="dcs-control-@0@"/>|<include name="DcsCore" version="@0@"/><package name="dcs-control-@0@"/>|'.format(libdcs_api_version),
                 ##'@INPUT@',
                 #join_paths(meson.current_build_dir(), 'Dcs-@0@.gir'.format(libdcs_api_version)),
               #],
        ##input: join_paths(meson.current_build_dir(), 'Dcs-@0@.gir'.format(libdcs_api_version)),
       #output: 'DcsControl-@0@.gir'.format(libdcs_api_version),
      #capture: true,
      #install: true,
  #install_dir: dir_gir,
#)

#custom_target('DcsDAQ-@0@.gir'.format(libdcs_api_version),
      #command: [ sed,
                 #'-e', 's|Dcs[.]|DcsDAQ.|g',
                 #'-e', 's|namespace name="Dcs"|namespace name="DcsDAQ"|g',
                 #'-e', 's|DcsDAQ[.]Node|DcsCore.Node|g',
                 #'-e', 's|DcsDAQ[.]PluginExtension|DcsCore.PluginExtension|g',
                 #'-e', 's|<package name="dcs-daq-@0@"/>|<include name="DcsCore" version="@0@"/><package name="dcs-daq-@0@"/>|'.format(libdcs_api_version),
                 #'@INPUT@',
               #],
        #input: join_paths(meson.current_build_dir(), 'Dcs-@0@.gir'.format(libdcs_api_version)),
       #output: 'DcsDAQ-@0@.gir'.format(libdcs_api_version),
      #capture: true,
      #install: true,
  #install_dir: dir_gir,
#)

#custom_target('DcsLog-@0@.gir'.format(libdcs_api_version),
      #command: [ sed,
                 #'-e', 's|Dcs[.]|DcsLog.|g',
                 #'-e', 's|namespace name="Dcs"|namespace name="DcsLog"|g',
                 #'-e', 's|DcsLog[.]Node|DcsCore.Node|g',
                 #'-e', 's|DcsLog[.]PluginExtension|DcsCore.PluginExtension|g',
                 #'-e', 's|<package name="dcs-log-@0@"/>|<include name="DcsCore" version="@0@"/><package name="dcs-log-@0@"/>|'.format(libdcs_api_version),
                 #'@INPUT@',
               #],
        #input: join_paths(meson.current_build_dir(), 'Dcs-@0@.gir'.format(libdcs_api_version)),
       #output: 'DcsLog-@0@.gir'.format(libdcs_api_version),
      #capture: true,
      #install: true,
  #install_dir: dir_gir,
#)

#custom_target('DcsUI-@0@.gir'.format(libdcs_api_version),
      #command: [ sed,
                 #'-e', 's|Dcs[.]|DcsUI.|g',
                 #'-e', 's|namespace name="Dcs"|namespace name="DcsUI"|g',
                 #'-e', 's|DcsUI[.]Object|DcsCore.Object|g',
                 #'-e', 's|DcsUI[.]Buildable|DcsCore.Buildable|g',
                 #'-e', 's|DcsUI[.]Container|DcsCore.Container|g',
                 #'-e', 's|DcsUI[.]CldAdapter|DcsCore.CldAdapter|g',
                 #'-e', 's|DcsUI[.]PluginExtension|DcsCore.PluginExtension|g',
                 #'-e', 's|DcsUI[.]Factory|DcsCore.Factory|g',
                 #'-e', 's|<package name="dcs-ui-@0@"/>|<include name="DcsCore" version="@0@"/><package name="dcs-ui-@0@"/>|'.format(libdcs_api_version),
                 #'@INPUT@',
               #],
        #input: join_paths(meson.current_build_dir(), 'Dcs-@0@.gir'.format(libdcs_api_version)),
       #output: 'DcsUI-@0@.gir'.format(libdcs_api_version),
      #capture: true,
      #install: true,
  #install_dir: dir_gir,
#)

# XXX an example of generating a typelib using the compiler directly

#if g_ir_compiler.found()
  #custom_target('DcsCLI-@0@.typelib'.format(libdcs_api_version),
        #command: [ g_ir_compiler,
                   #'--shared-library', libdcs_cli.full_path(),
                   #'--includedir', libdcs_girdir,
                   #'--output', '@OUTPUT@',
                   #'@INPUT@',
                 #],
          #input: join_paths(meson.current_build_dir(), 'DcsCLI-@0@.gir'.format(libdcs_api_version)),
         #output: 'DcsCLI-@0@.typelib'.format(libdcs_api_version),
        #depends: libdcs_cli,
        #install: true,
    #install_dir: dir_typelib,
#)
#endif
