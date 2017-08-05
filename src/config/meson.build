# Took this idea from Budgie
# A simple .a archive to fix linking in Vala builds by restricting defines to
# one place.

libconfig_sources = [
  'dcs-config.c',
]

libconfig = static_library('config', libconfig_sources,
  include_directories: include_directories('.'),
)

link_libconfig = declare_dependency(
            link_with: libconfig,
  include_directories: include_directories('.'),
)

# Expose the currect directory so that we can use vapidir
dir_libconfig = meson.current_source_dir()
