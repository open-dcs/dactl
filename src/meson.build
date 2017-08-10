subdir('config')

# XXX these should just be added to project or global
common_c_args = []
common_vala_args = [
  '--vapidir', dir_libconfig,
  '--pkg', 'libzmq',
  '--pkg', 'libsoup-2.4',
  '--pkg', 'dcs-config',
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
  libcomedi_dep,
  dep_posix,
  dep_linux,
]

# XXX move these into libdcs-ui build
# GUI deps
if get_option('with-ui')
  dep_peasgtk = dependency('libpeas-gtk-1.0', version: '>= 1.20.0')
  dep_gtk = dependency('gtk+-3.0', version: '>= 3.22.0')
  dep_gtksource = dependency('gtksourceview-3.0', version: '>= 3.22.0')
  dep_rsvg = dependency('librsvg-2.0', version: '>= 2.40.0')
endif

# Libraries
subdir('libdcs')

# Plugins
subdir('plugins')

# Executables
#subdir('dcs')
subdir('dcsg')
subdir('services')
