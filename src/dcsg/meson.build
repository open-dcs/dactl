if get_option('with-ui')

dcsg_resources = gnome.compile_resources('dcsg-resources',
  'dcsg.gresource.xml',
  c_name: 'dcsg',
)

dcsg_sources = [
  'dcsg-application.vala',
  'dcsg-cmdline-config.vala',
  'dcsg-configuration-editor.vala',
  'dcsg-configuration-toolbar.vala',
  'dcsg-controller.vala',
  'dcsg-csv-export-toolbar.vala',
  'dcsg-csv-export.vala',
  'dcsg-dbus-service.vala',
  'dcsg-general-settings.vala',
  'dcsg-layout.vala',
  'dcsg-loader-toolbar.vala',
  'dcsg-loader.vala',
  'dcsg-main.vala',
  'dcsg-menu.vala',
  'dcsg-model.vala',
  'dcsg-plugin-settings.vala',
  'dcsg-settings-data.vala',
  'dcsg-settings-dialog.vala',
  'dcsg-settings-listbox.vala',
  'dcsg-settings-page.vala',
  'dcsg-settings-sidebar.vala',
  'dcsg-settings-toolbar.vala',
  'dcsg-settings-topbar.vala',
  'dcsg-settings-treeview.vala',
  'dcsg-sidebar.vala',
  'dcsg-toolbar.vala',
  'dcsg-topbar.vala',
  'dcsg-utility.vala',
  'dcsg-ux-manager.vala',
  'dcsg-window.vala',
]

dcsg_c_args = exe_c_args + [
  '-DG_LOG_DOMAIN="dcsg"',
]

dcsg_vala_args = common_vala_args + []

vapi_glibextra = meson.get_compiler('vala').find_library('glib-extra', dirs: join_paths(meson.source_root(), 'vapi'))
dep_glibextra = declare_dependency(dependencies: vapi_glibextra)

dcsg_deps = [
  libdcs_dep,
  dep_peasgtk,
  dep_glibextra,
]

executable('dcsg', dcsg_sources + dcsg_resources,
        gui_app: true,
        install: true,
         c_args: dcsg_c_args,
      vala_args: dcsg_vala_args,
      link_args: exe_link_args,
  install_rpath: pkglibdir_abs,
   dependencies: dcsg_deps,
)

endif
