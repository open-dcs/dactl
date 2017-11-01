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
  dep_gio,
  dep_gee,
  dep_gsl,
  dep_peas,
  dep_json,
  dep_xml,
  dep_cld,
  dep_zmq,
  dep_soup,
  #dep_comedi,
  dep_posix,
  dep_linux,
]

subdir('libdcs')
subdir('plugins')

exe_link_args = [ '-pie' ]
exe_c_args = [ '-fPIE' ]

#subdir('dcs')
subdir('dcsg')
subdir('services')
