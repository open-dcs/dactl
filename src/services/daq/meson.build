daq_sources = [
  'cmdline-config.vala',
  'config.vala',
  'dbus-service.vala',
  'main.vala',
  'router.vala',
  'server.vala',
]

daq_c_args = exe_c_args + [
  '-DG_LOG_DOMAIN="dcs-daq"',
]

daq_vala_args = common_vala_args + []

daq_deps = [
  libdcs_dep,
]

executable('dcs-daq', daq_sources,
        gui_app: true,
        install: true,
         c_args: daq_c_args,
      vala_args: daq_vala_args,
      link_args: exe_link_args,
  install_rpath: pkglibdir_abs,
   dependencies: daq_deps,
)
