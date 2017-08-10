log_sources = [
  'cmdline-config.vala',
  'config.vala',
  'dbus-service.vala',
  'main.vala',
  'router.vala',
  'server.vala',
]

log_c_args = exe_c_args + [
  '-DG_LOG_DOMAIN="dcs-log"',
]

log_vala_args = common_vala_args + []

log_deps = [
  libdcs_log_dep,
]

executable('dcs-log', log_sources,
        gui_app: true,
        install: true,
         c_args: log_c_args,
      vala_args: log_vala_args,
      link_args: exe_link_args,
  install_rpath: pkglibdir_abs,
   dependencies: log_deps,
)
