project('dcs', [ 'c', 'vala' ],
          license: 'GPL3+',
          version: '0.3.0',
    meson_version: '>= 0.40.1',
  default_options: [
                     'c_std=gnu11',
                     'warning_level=2',
                   ],
)

version_split = meson.project_version().split('.')
MAJOR_VERSION = version_split[0]
MINOR_VERSION = version_split[1]
MICRO_VERSION = version_split[2]

status = [
  '', '',
  'OpenDCS @0@'.format(meson.project_version()),
  '', '',
]

# Warning message
if (version_split[1].to_int() % 2 == 1)
  status += [
    'You are building a debug version of OpenDCS. There may be more bugs in',
    'this version that you are comfortable with.',
    '', ''
  ]
endif

status += [
  'Version ............................... : @0@'.format(meson.project_version()),
  'Build Type ............................ : @0@'.format(get_option('buildtype')),
  '',
  'Prefix ................................ : @0@'.format(get_option('prefix')),
  'Libdir ................................ : @0@'.format(join_paths(get_option('prefix'), get_option('libdir'))),
  '',
  'Tracing ............................... : @0@'.format(get_option('enable-tracing')),
  'Profiling ............................. : @0@'.format(get_option('enable-profiling')),
  '', ''
]

add_global_arguments([
  '-DHAVE_CONFIG_H',
  '-I' + meson.build_root(), # config.h
  '-D_GNU_SOURCE',
  '-DDCS_COMPILATION',
  '-DGETTEXT_PACKAGE="dcs"',
], language: 'c')

add_project_arguments([
  '--thread',
  ['--target-glib', '2.38'],
  ['--vapidir', join_paths(meson.current_source_dir(), 'vapi')],
], language: 'vala')

# Commonly used deps
libgio_dep = dependency('gio-2.0', version: '>= 2.44.0')
libgee_dep = dependency('gee-0.8', version: '>= 0.18.0')
libgsl_dep = dependency('gsl', version: '>= 2.1')
libpeas_dep = dependency('libpeas-1.0', version: '>= 1.20.0')
libjson_glib_dep = dependency('json-glib-1.0', version: '>= 1.2.0')
libxml_dep = dependency('libxml-2.0', version: '>= 2.9.0')
libzmq_dep = dependency('libzmq', version: '>= 3.2.0')
libsoup_dep = dependency('libsoup-2.4', version: '>= 2.50.0')
libcld_dep = dependency('cld-1.0', version: '>= 0.4.0')
libtemplate_glib_dep = dependency('template-glib-1.0', version: '>= 3.25.3', required: false)

libcomedi_lib = meson.get_compiler('c').find_library('comedi')
libcomedi_vapi = meson.get_compiler('vala').find_library('comedi', dirs: join_paths(meson.current_source_dir(), 'vapi'))
libcomedi_dep = declare_dependency(dependencies: [libcomedi_lib, libcomedi_vapi])

dep_posix = meson.get_compiler('vala').find_library('posix')
dep_linux = meson.get_compiler('vala').find_library('linux')

libcld_gir = 'Cld-1.0'
libcld_vapi = 'cld-1.0'
if not libcld_dep.found()
  libcld = subproject('cld',
    default_options: [
      'package_subdir=' + meson.project_name()
    ]
  )
  libcld_dep = libcld.get_variable('libcld_dep')
  libcld_gir = libcld.get_variable('libcld_gir')[0]
  libcld_vapi = libcld.get_variable('libcld_vapi')
endif

libtemplate_glib_gir = 'Template-1.0'
libtemplate_glib_vapi = 'template-glib-1.0'
if not libtemplate_glib_dep.found()
  libtemplate_glib = subproject('template-glib',
    default_options: [
      'with_introspection=true',
      'with_vapi=true',
      'package_subdir=' + meson.project_name()
    ]
  )
  libtemplate_glib_dep = libtemplate_glib.get_variable('libtemplate_glib_dep')
  libtemplate_glib_gir = libtemplate_glib.get_variable('libtemplate_glib_gir')[0]
  libtemplate_glib_vapi = libtemplate_glib.get_variable('libtemplate_glib_vapi')
endif

# Create config.h
conf = configuration_data()

# Global paths that we need
pkgdocdir_abs = join_paths(get_option('prefix'), get_option('datadir'), 'doc', 'dcs')
pkglibdir_abs = join_paths(get_option('prefix'), get_option('libdir'), 'dcs')
pkglibdir = join_paths(get_option('libdir'), 'dcs')
pkgincludedir = join_paths(get_option('includedir'), 'dcs')
pkggirdir = join_paths(get_option('datadir'),'dcs', 'gir-1.0')
pkgtypelibdir = join_paths(get_option('libdir'), 'dcs', 'girepository-1.0')
pkgvapidir = join_paths(get_option('datadir'), 'dcs/vapi')

# XXX these are redundant and need to be merged into one, need to decide on this vs. pkg*
dir_lib = join_paths(get_option('prefix'), get_option('libdir'))
dir_sysconfig = join_paths(get_option('prefix'), 'etc')
dir_data = join_paths(get_option('prefix'), get_option('datadir'))
dir_template = join_paths(dir_data, 'dcs', 'templates')
dir_gir = join_paths(get_option('datadir'), 'gir-1.0')
dir_typelib = join_paths(get_option('libdir'), 'girepository-1.0')

conf.set10('ENABLE_NLS', true) # Always enabled
conf.set_quoted('PACKAGE_NAME', 'dcs')
conf.set_quoted('PACKAGE_VERSION', meson.project_version())
conf.set_quoted('PACKAGE_STRING', 'dcs-' + meson.project_version())
conf.set_quoted('PACKAGE_LIBDIR', join_paths(dir_lib, 'dcs'))
conf.set_quoted('PACKAGE_LIBEXECDIR', join_paths(get_option('prefix'), get_option('libexecdir')))
conf.set_quoted('PACKAGE_CONFDIR', join_paths(dir_sysconfig, 'dcs'))
conf.set_quoted('PACKAGE_DATADIR', join_paths(dir_data, 'dcs'))
conf.set_quoted('PACKAGE_DOCDIR', join_paths(dir_data, 'doc', 'dcs'))
conf.set_quoted('PACKAGE_LOCALE_DIR', join_paths(dir_data, 'locale'))
conf.set_quoted('PACKAGE_URL', 'https://github.com/open-dcs/dcs/')

# For i18n
conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())

# TODO old configuration from autotools that need to be moved into libconfig
conf.set('LOCALEDIR', 'PACKAGE_LOCALE_DIR')
conf.set_quoted('SYS_CONFIG_DIR', dir_sysconfig)
conf.set_quoted('TEMPLATE_DIR', dir_template)

if get_option('with-ui')
  dir_webkit_extension = join_paths(get_option('prefix'), get_option('libdir'), 'dcs', 'extensions')
  conf.set_quoted('WEB_EXTENSION_DIR', dir_webkit_extension)
endif

# Configuration for logging plugins
backenddir = join_paths(get_option('prefix'), get_option('libdir'), 'dcs/backends')
backenddatadir = join_paths(get_option('prefix'), get_option('datadir'), 'dcs/backend')
backendconfdir = join_paths(get_option('prefix'), get_option('sysconfdir'), 'dcs/backend')

conf.set_quoted('BACKEND_DIR', backenddir)
conf.set_quoted('BACKEND_CONF_DIR', backendconfdir)
conf.set_quoted('BACKEND_DATA_DIR', backenddatadir)

# Configuration for feedback control plugins
controllerdir = join_paths(get_option('prefix'), get_option('libdir'), 'dcs/controllers')
controllerdatadir = join_paths(get_option('prefix'), get_option('datadir'), 'dcs/controller')
controllerconfdir = join_paths(get_option('prefix'), get_option('sysconfdir'), 'dcs/controller')

conf.set_quoted('CONTROLLER_DIR', controllerdir)
conf.set_quoted('CONTROLLER_CONF_DIR', controllerconfdir)
conf.set_quoted('CONTROLLER_DATA_DIR', controllerdatadir)

# Configuration for device plugins
devicedir = join_paths(get_option('prefix'), get_option('libdir'), 'dcs/devices')
devicedatadir = join_paths(get_option('prefix'), get_option('datadir'), 'dcs/device')
deviceconfdir = join_paths(get_option('prefix'), get_option('sysconfdir'), 'dcs/device')

conf.set_quoted('DEVICE_DIR', devicedir)
conf.set_quoted('DEVICE_CONF_DIR', deviceconfdir)
conf.set_quoted('DEVICE_DATA_DIR', devicedatadir)

# Configuration for UI plugins
plugindir = join_paths(get_option('prefix'), get_option('libdir'), 'dcs/plugins')
plugindatadir = join_paths(get_option('prefix'), get_option('datadir'), 'dcs/plugin')
pluginconfdir = join_paths(get_option('prefix'), get_option('sysconfdir'), 'dcs/plugin')

conf.set_quoted('PLUGIN_DIR', plugindir)
conf.set_quoted('PLUGIN_CONF_DIR', pluginconfdir)
conf.set_quoted('PLUGIN_DATA_DIR', plugindatadir)

# Write config.h
configure_file(
         output: 'config.h',
  configuration: conf
)

# Enable others to find this .h file
extra_includes = [
  include_directories('.'),
]

# XXX may not need these for anything if using gnome module correctly
sed = find_program('sed')
g_ir_compiler = find_program('g-ir-compiler', required: false)

gnome = import('gnome')
i18n = import('i18n')

# Prep translations prior to build
subdir('po')

# TODO these may be needed by Peas plugins, double check later and remove if not
exe_link_args = [ '-pie' ]
exe_c_args = [ '-fPIE' ]

# Build all the libs and executables
subdir('src')
subdir('tests')
subdir('examples')

# Documentation
subdir('doc')

# All the data to be installed
subdir('data')

meson.add_install_script('build-aux/meson/meson_post_install.py')

# 'dist' will be used by meson, avoid conflicting
run_target('dcs-dist',
  command: [
    find_program('build-aux/meson/meson_dist.sh'),
    meson.project_version(),
    meson.project_name(),
  ]
)

message('\n  '.join(status))
