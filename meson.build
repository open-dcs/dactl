project('dcs', 'vala', 'c',
          license: 'GPL3+',
          version: '0.3.0',
    meson_version: '>= 0.40.1',
  default_options: [
                     'c_std=gnu11',
                     'cpp_std=c++11',
                     'warning_level=2',
                   ],
)

version_split = meson.project_version().split('.')
MAJOR_VERSION = version_split[0]
MINOR_VERSION = version_split[1]
MICRO_VERSION = version_split[2]

pkgdocdir_abs = join_paths(get_option('prefix'), get_option('datadir'), 'doc', 'dcs')
pkglibdir_abs = join_paths(get_option('prefix'), get_option('libdir'), 'dcs')
pkglibdir = join_paths(get_option('libdir'), 'dcs')
pkgincludedir = join_paths(get_option('includedir'), 'dcs')
pkggirdir = join_paths(get_option('datadir'),'dcs', 'gir-1.0')
pkgtypelibdir = join_paths(get_option('libdir'), 'dcs', 'girepository-1.0')
pkgvapidir = join_paths(get_option('datadir'), 'dcs/vapi')

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
  'Tracing ............................... : @0@'.format(get_option('enable_tracing')),
  'Profiling ............................. : @0@'.format(get_option('enable_profiling')),
  '', ''
]

conf = configuration_data()
conf.set_quoted('PACKAGE_NAME', 'dcs')
conf.set_quoted('PACKAGE_VERSION', meson.project_version())
conf.set_quoted('PACKAGE_STRING', 'dcs-' + meson.project_version())
conf.set_quoted('PACKAGE_DATADIR', join_paths(get_option('prefix'), get_option('datadir')))
conf.set_quoted('PACKAGE_DOCDIR', join_paths(get_option('prefix'), get_option('datadir'), 'doc/dcs'))
conf.set_quoted('PACKAGE_LIBDIR', join_paths(get_option('prefix'), get_option('libdir')))
conf.set_quoted('PACKAGE_LOCALE_DIR', join_paths(get_option('prefix'), get_option('datadir'), 'locale'))
conf.set_quoted('PACKAGE_LIBEXECDIR', join_paths(get_option('prefix'), get_option('libexecdir')))
conf.set_quoted('PACKAGE_URL', 'https://github.com/open-dcs/dcs/')

conf.set('GETTEXT_PACKAGE', 'PACKAGE_NAME')
conf.set('LOCALEDIR', 'PACKAGE_LOCALE_DIR')

conf.set10('ENABLE_NLS', true) # Always enabled

add_global_arguments([
  '-DHAVE_CONFIG_H',
  '-I' + meson.build_root(), # config.h
  '-D_GNU_SOURCE',
  '-DDCS_COMPILATION',
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

#libcomedi_vapi = meson.get_compiler('vala').find_library('comedi', dirs: join_paths(meson.current_source_dir(), 'vapi'))
#libcomedi_dep = declare_dependency(dependencies: [libcomedi_vapi])

comedi_dep = meson.get_compiler('vala').find_library('comedi')
posix_dep = meson.get_compiler('vala').find_library('posix')
linux_dep = meson.get_compiler('vala').find_library('linux')

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

common_c_args = []

common_vala_args = [
  '--vapidir', join_paths(meson.source_root(), 'vapi'),
  '--pkg', 'libzmq',
  '--pkg', 'libsoup-2.4',
]

common_deps = [
  libgio_dep,
  libgee_dep,
  libgsl_dep,
  libpeas_dep,
  libjson_glib_dep,
  libxml_dep,
  libcld_dep,
  libzmq_dep,
  libsoup_dep,
  #libcomedi_dep,
  comedi_dep,
  posix_dep,
  linux_dep,
]

sed = find_program('sed')
g_ir_compiler = find_program('g-ir-compiler', required: false)

dir_gir = join_paths(get_option('datadir'), 'gir-1.0')
dir_typelib = join_paths(get_option('libdir'), 'girepository-1.0')

gnome = import('gnome')
i18n = import('i18n')

subdir('data')
subdir('po')
subdir('src')
subdir('doc')
subdir('examples')
subdir('tests')

configure_file(
         output: 'config.h',
  configuration: conf
)

# Enable others to find this .h file
extra_includes = [
  include_directories('.'),
]

exe_link_args = [ '-pie' ]
exe_c_args = [ '-fPIE' ]

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
