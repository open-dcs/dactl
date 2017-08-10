control_sources = [
  'cmdline-config.vala',
  'config.vala',
  'dbus-service.vala',
  'main.vala',
  'router.vala',
  'server.vala',
]

control_c_args = exe_c_args + [
  '-DG_LOG_DOMAIN="dcs-control"',
]

control_vala_args = common_vala_args + []

control_deps = [
  libdcs_control_dep,
]

executable('dcs-control', control_sources,
        gui_app: true,
        install: true,
         c_args: control_c_args,
      vala_args: control_vala_args,
      link_args: exe_link_args,
  install_rpath: pkglibdir_abs,
   dependencies: control_deps,
)
