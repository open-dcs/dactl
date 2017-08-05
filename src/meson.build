# GUI deps
if get_option('with_ui')
  libgtk_dep = dependency('gtk+-3.0', version: '>= 3.22.0')
  libgtksource_dep = dependency('gtksourceview-3.0', version: '>= 3.22.0')
endif

subdir('config')

common_vala_args = [
  '--vapidir', dir_libconfig,
  '--pkg', 'dcs-config',
]

# Libraries
subdir('lib')
subdir('lib/core')
subdir('lib/cli')
subdir('lib/control')
subdir('lib/daq')
subdir('lib/log')
subdir('lib/net')
subdir('lib/ui')

# Plugins
subdir('plugins')
subdir('plugins/backends')
subdir('plugins/controllers')
subdir('plugins/devices')
subdir('plugins/ui-modules')

# Executables
subdir('dcsg')
subdir('services')
subdir('services/control')
subdir('services/daq')
subdir('services/log')
