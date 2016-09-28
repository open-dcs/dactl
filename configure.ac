AC_PREREQ([2.69])


dnl ***********************************************************************
dnl Define Versioning Information
dnl ***********************************************************************
m4_define([dcs_major_version],[0])
m4_define([dcs_minor_version],[1])
m4_define([dcs_micro_version],[0])
m4_define([dcs_version],[dcs_major_version.dcs_minor_version.dcs_micro_version])
m4_define([dcs_interface_age],[0])
m4_define([dcs_bugreport_url],
          [https://github.com/open-dcs/dcs/issues])
m4_define([dcs_debug_default],
          [m4_if(m4_eval(dcs_minor_version % 2), [1], [yes], [minimum])])


dnl ***********************************************************************
dnl Initialize Autoconf
dnl ***********************************************************************
AC_INIT([dcs],
        [dcs_version],
        [dcs_bugreport_url],
        [dcs],
        [https://github.com/open-dcs/dcs])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_SRCDIR([src/dcs/dcs-main.vala])
AC_CONFIG_MACRO_DIR([build/autotools])
AC_CONFIG_AUX_DIR([build])
AC_SUBST(ACLOCAL_AMFLAGS, "-I build/autotools")
AC_CANONICAL_HOST


dnl ***********************************************************************
dnl Make Version Info Available to .in Files
dnl ***********************************************************************
MAJOR_VERSION=dcs_major_version
MINOR_VERSION=dcs_minor_version
MICRO_VERSION=dcs_micro_version
LIBDCS_CORE_VERSION=dcs_version
LIBDCS_CLI_VERSION=dcs_version
LIBDCS_DAQ_VERSION=dcs_version
LIBDCS_LOG_VERSION=dcs_version
LIBDCS_NET_VERSION=dcs_version
LIBDCS_UI_VERSION=dcs_version
AC_SUBST(MAJOR_VERSION)
AC_SUBST(MINOR_VERSION)
AC_SUBST(MICRO_VERSION)
AC_SUBST(LIBDCS_CORE_VERSION)
AC_SUBST(LIBDCS_CLI_VERSION)
AC_SUBST(LIBDCS_DAQ_VERSION)
AC_SUBST(LIBDCS_LOG_VERSION)
AC_SUBST(LIBDCS_NET_VERSION)
AC_SUBST(LIBDCS_UI_VERSION)


dnl ***********************************************************************
dnl Initialize Automake
dnl ***********************************************************************
AM_SILENT_RULES([yes])
AM_INIT_AUTOMAKE([1.11 foreign subdir-objects tar-ustar no-dist-gzip dist-xz])
AM_MAINTAINER_MODE([enable])


dnl ***********************************************************************
dnl Internationalization
dnl ***********************************************************************
AX_REQUIRE_DEFINED([IT_PROG_INTLTOOL])
IT_PROG_INTLTOOL([0.50.1])
GETTEXT_PACKAGE=AC_PACKAGE_TARNAME
AC_DEFINE_UNQUOTED([GETTEXT_PACKAGE], ["$GETTEXT_PACKAGE"], [GETTEXT package name])
AC_SUBST(GETTEXT_PACKAGE)
AM_GLIB_GNU_GETTEXT


dnl ***********************************************************************
dnl Check for Required Programs
dnl ***********************************************************************
AC_PROG_CC
AM_PROG_CC_C_O
AC_PROG_CXX
AM_PROG_VALAC([0.30.0])
AM_PATH_PYTHON([2.5])
AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_MAKE_SET
AC_PATH_PROG([GLIB_GENMARSHAL], [glib-genmarshal])
AC_PATH_PROG([GLIB_MKENUMS], [glib-mkenums])
AC_PATH_PROG([GLIB_COMPILE_RESOURCES], [glib-compile-resources])
AC_HEADER_STDC
PKG_PROG_PKG_CONFIG([0.22])
GOBJECT_INTROSPECTION_CHECK([1.42.0])
VAPIGEN_CHECK
GLIB_GSETTINGS
APPSTREAM_XML

AC_ARG_VAR([DESKTOP_FILE_VALIDATE], [the desktop-file-validate program])
AC_PATH_PROG([DESKTOP_FILE_VALIDATE], [desktop-file-validate], [])
if test -z "$DESKTOP_FILE_VALIDATE"; then
	AC_MSG_ERROR([desktop-file-validate not found])
fi


dnl ***********************************************************************
dnl Check for Required Headers
dnl ***********************************************************************
AC_CHECK_HEADERS(stdlib.h)
AC_CHECK_LIB(m, floor, PACKAGE_LIBS="$PACKAGE_LIBS -lm",)


dnl * XXX *****************************************************************
dnl *  - not sure if anything from here

AC_SUBST(abs_top_builddir)
GOBJECT_INTROSPECTION_REQUIRE([0.9.0])
AC_SET_DEFAULT_PATHS_SYSTEM
SYSCONFDIR="$ac_default_prefix/etc"
AC_SUBST(SYSCONFDIR)
dnl Add setup for installation directories
AC_DEFINE_UNQUOTED(DATADIR, "$SYSCONFDIR/$PACKAGE",
                   [Define the architecture-independent data directory.])
AC_DEFINE_UNQUOTED(UI_DIR, "$ac_default_prefix/share/$PACKAGE/ui",
                   [Define the read-only user interface files directory.])

dnl *  - to here is required
dnl * XXX *****************************************************************


dnl ***********************************************************************
dnl Systemd service unit file location
dnl ***********************************************************************
AC_ARG_WITH([systemd-unitdir],
	AS_HELP_STRING([--with-systemd-unitdir], [Directory for systemd service files]),
	[SYSTEMD_UNITDIR=$withval], [SYSTEMD_UNITDIR="\${prefix}/lib/systemd/system"])
AC_SUBST(SYSTEMD_UNITDIR)


dnl ***********************************************************************
dnl Allow user to update application mime type
dnl - always enabling results in slow make install w/ update-mime-database
dnl ***********************************************************************
AC_ARG_ENABLE(mime,
              AS_HELP_STRING([--enable-mime=@<:@no/yes@:>@],
                             [update mime database @<:@default=no@:>@]),
              ,
              enable_mime=no)
AS_IF([test "x$enable_mime" = "xyes"],[enable_mime=yes ENABLE_MIME=1],[ENABLE_MIME=0])
AC_SUBST(ENABLE_MIME)
AM_CONDITIONAL(ENABLE_MIME, test "x$enable_mime" = "xyes")


dnl ***********************************************************************
dnl Setup Debug and Tracing Support
dnl ***********************************************************************
AC_ARG_ENABLE(tracing,
              AS_HELP_STRING([--enable-tracing=@<:@no/yes@:>@],
                             [add extra debugging information @<:@default=no@:>@]),
              ,
              enable_tracing=no)
AS_IF([test "x$enable_tracing" = "xyes"],[enable_debug=yes ENABLE_TRACING=1],[ENABLE_TRACING=0])
AC_SUBST(ENABLE_TRACING)

AC_ARG_ENABLE(debug,
              AS_HELP_STRING([--enable-debug=@<:@no/minimum/yes@:>@],
                             [turn on debugging @<:@default=dcs_debug_default@:>@]),
              ,
              enable_debug=dcs_debug_default)
AS_CASE(["$enable_debug"],
        [yes],[
            DEBUG_CFLAGS="$DEBUG_CFLAGS -O0"
            DEBUG_CFLAGS="$DEBUG_CFLAGS -g"
        ],
        [minimum],[
            DEBUG_CFLAGS="$DEBUG_CFLAGS -DG_DISABLE_CAST_CHECKS"
        ],
        [no],[
            DEBUG_CFLAGS="$DEBUG_CFLAGS -DG_DISABLE_ASSERT"
            DEBUG_CFLAGS="$DEBUG_CFLAGS -DG_DISABLE_CHECKS"
            DEBUG_CFLAGS="$DEBUG_CFLAGS -DG_DISABLE_CAST_CHECKS"
        ],
        [])
AC_SUBST(DEBUG_CFLAGS)

BUGREPORT_URL=dcs_bugreport_url
AC_SUBST(BUGREPORT_URL)


dnl ***********************************************************************
dnl Check for Required Packages
dnl ***********************************************************************
m4_define([cld_required_version], [0.3.0])
m4_define([comedi_required_version], [0.8.1])
m4_define([gee_required_version], [0.18.0])
m4_define([glib_required_version], [2.46.0])
m4_define([gtk_required_version], [3.18.1])
m4_define([json_required_version], [1.0.0])
m4_define([libxml_required_version], [2.9.0])
m4_define([peas_required_version], [1.16.0])
m4_define([rsvg_required_version], [2.40.0])
m4_define([soup_required_version], [2.4.0])
m4_define([zmq_required_version], [3.2.0])

PKG_CHECK_MODULES(LIBDCS_CORE, [gio-2.0 >= glib_required_version
                                gee-0.8 >= gee_required_version
                                libxml-2.0 >= libxml_required_version
                                libpeas-1.0 >= peas_required_version
                                cld-0.3 >= cld_required_version])
PKG_CHECK_MODULES(LIBDCS_CLI, [glib-2.0 >= glib_required_version
                               gee-0.8 >= gee_required_version
                               libxml-2.0 >= libxml_required_version
                               libpeas-1.0 >= peas_required_version
                               cld-0.3 >= cld_required_version])
PKG_CHECK_MODULES(LIBDCS_DAQ, [glib-2.0 >= glib_required_version
                               gee-0.8 >= gee_required_version
                               libpeas-1.0 >= peas_required_version
                               cld-0.3 >= cld_required_version])
PKG_CHECK_MODULES(LIBDCS_LOG, [gio-2.0 >= glib_required_version
                               gee-0.8 >= gee_required_version
                               libpeas-1.0 >= peas_required_version
                               libzmq >= zmq_required_version
                               cld-0.3 >= cld_required_version])
PKG_CHECK_MODULES(LIBDCS_NET, [gee-0.8 >= gee_required_version
                               json-glib-1.0 >= json_required_version
                               libpeas-1.0 >= peas_required_version
                               libsoup-2.4 >= soup_required_version
                               libzmq > zmq_required_version
                               cld-0.3 >= cld_required_version])
PKG_CHECK_MODULES(LIBDCS_UI, [gio-2.0 >= glib_required_version
                              gee-0.8 >= gee_required_version
                              gtk+-3.0 >= gtk_required_version
                              gtksourceview-3.0 >= gtk_required_version
                              cld-0.3 >= cld_required_version
                              json-glib-1.0 >= json_required_version
                              libxml-2.0 >= libxml_required_version
                              libpeas-1.0 >= peas_required_version
                              libpeas-gtk-1.0 >= peas_required_version
                              librsvg-2.0 >= rsvg_required_version
                              libsoup-2.4 >= soup_required_version])


dnl Need to work these in to simplify checking
DCS_BASE_MODULES="gee-0.8 libxml-2.0 libpeas-1.0"
DCS_BASE_MODULES_VALAFLAGS="--pkg gee-0.8 --pkg libxml-2.0 --pkg glib-extra --pkg libpeas-1.0"

DCS_COMMON_MODULES="$DCS_BASE_MODULES"
DCS_COMMON_MODULES_VALAFLAGS="$DCS_BASE_MODULES_VALAFLAGS"
AC_SUBST([DCS_COMMON_MODULES_VALAFLAGS])

PKG_CHECK_MODULES([DCS_DEPS], [$DCS_COMMON_MODULES gio-2.0 gmodule-2.0])
DCS_DEPS_VALAFLAGS="$DCS_COMMON_MODULES_VALAFLAGS --pkg gio-2.0 --pkg gmodule-2.0"
AC_SUBST([DCS_DEPS_VALAFLAGS])

PKG_CHECK_MODULES([DCS_UI_DEPS], [gtk+-3.0 librsvg-2.0 gtksourceview-3.0 libsoup-2.4])
DCS_UI_MODULES="gtk+-3.0 librsvg-2.0 gtksourceview-3.0 libsoup-2.4"
DCS_UI_DEPS_VALAFLAGS="--pkg gtk+-3.0 --pkg cogl-1.0 --pkg librsvg-2.0 --pkg gtksourceview-3.0 --pkg libsoup-2.4"
AC_SUBST([DCS_UI_DEPS_VALAFLAGS])
DCS_PLUGIN_COMMON_VALAFLAGS="$DCS_PLUGIN_COMMON_VALAFLAGS $DCS_UI_DEPS_VALAFLAGS"

dnl Check if building CLD support was requested
dnl XXX CLD is more of a requirement than an option at this point but the hope
dnl     is that dcs can be more generic and function with it as an engine
AC_ARG_WITH(cld,
    AS_HELP_STRING([--without-cld], [Do not build with CLD support]),
    [try_cld=$withval], [try_cld=yes])

HAVE_CLD=no
AS_IF([test "x$try_cld" = "xyes"],
      [PKG_CHECK_MODULES([DCS_CLD_DEPS], [cld-0.3 comedi gio-2.0 gsl sqlite3 gee-0.8 libxml-2.0],
	    [
           DCS_CHECK_PACKAGES([cld-0.3 comedi gio-2.0 gsl sqlite3 gee-0.8 libxml-2.0], [HAVE_CLD=yes])
           DCS_CLD_DEPS_VALAFLAGS="--pkg cld-0.3 --pkg comedi --pkg gio-2.0 --pkg gsl --pkg sqlite3 --pkg gee-0.8 --pkg libxml-2.0"
	       DCS_PLUGIN_COMMON_VALAFLAGS="$DCS_PLUGIN_COMMON_VALAFLAGS $DCS_CLD_DEPS_VALAFLAGS"
           AC_SUBST([DCS_CLD_DEPS_VALAFLAGS])
        ],
        [
          AC_MSG_WARN([CLD dependencies not found.])
          AC_MSG_WARN([CLD support will not be built.])
        ])])

AM_CONDITIONAL(USE_CLD, test "x$HAVE_CLD" = "xyes")


dnl ***********************************************************************
dnl Check if pygobject is available
dnl ***********************************************************************
m4_define([pygobject_required_version], [3.18.0])
PKG_CHECK_MODULES(PYGOBJECT,[pygobject-3.0 >= pygobject_required_version],
                            [have_pygobject=yes]
                            [have_pygobject=no])


dnl ***********************************************************************
dnl Check if we have WebKit support
dnl ***********************************************************************
m4_define([webkit_required_version], [2.12.0])
AC_ARG_ENABLE([webkit],
              [AS_HELP_STRING([--enable-webkit=@<:@yes/no/auto@:>@],
                              [Build with support for webkit.])],
              [enable_webkit=$enableval],
              [enable_webkit=auto])
AS_IF([test "$enable_webkit" != no],[
	PKG_CHECK_MODULES(WEBKIT,
	                  [webkit2gtk-web-extension-4.0 >= webkit_required_version],
	                  [have_webkit=yes],
	                  [have_webkit=no])

	AS_IF([test "$enable_webkit" = "yes" && "$have_webkit" = "no"],[
	       AC_MSG_ERROR([--enable-webkit requires webkit2gtk-4.0 >= webkit_required_version])
	])

	AC_SUBST([WEB_EXTENSION_DIR],[${libdir}/dcs/extensions])

	enable_webkit=$have_webkit
])
AM_CONDITIONAL(ENABLE_WEBKIT, [test "x$enable_webkit" = "xyes"])


dnl ***********************************************************************
dnl Check if we're building the Python plugin generator utility
dnl ***********************************************************************
AC_ARG_ENABLE([plugin-util],
              [AS_HELP_STRING([--enable-plugin-util=@<:@yes.no@:>@],
                              [Build the plugin generator.])],
              [enable_plugin_util=$enableval],
              [enable_plugin_util=no])
AM_CONDITIONAL(ENABLE_PLUGIN_UTIL, [test "x$enable_plugin_util" = "xyes"])


dnl ***********************************************************************
dnl Check for supported plugins
dnl ***********************************************************************
m4_include([src/plugins/samples/python/configure.ac])
m4_include([src/plugins/samples/vala/configure.ac])

AC_SUBST([PLUGIN_DIR],[${libdir}/dcs/plugins])


dnl ***********************************************************************
dnl Check for supported devices
dnl ***********************************************************************
m4_include([src/devices/comedi/configure.ac])
m4_include([src/devices/mccusb/configure.ac])
m4_include([src/devices/arduino/configure.ac])

AC_SUBST([DEVICE_DIR],[${libdir}/dcs/devices])


dnl ***********************************************************************
dnl Check for supported backends
dnl ***********************************************************************
m4_include([src/backends/xml/configure.ac])

AC_SUBST([BACKEND_DIR],[${libdir}/dcs/backends])


dnl ***********************************************************************
dnl Check for Required Python
dnl ***********************************************************************
enable_python_scripting=no
AS_IF([test "x$have_pygobject" = "xyes"],[
	AM_PATH_PYTHON([3.2.3])
	AC_PATH_TOOL(PYTHON3_CONFIG, "python3-config")
	AS_IF([test -z "${PYTHON3_CONFIG}"],[
		AC_MSG_RESULT([Failed to locate python3-config.])
	],[
		LIBDCS_CORE_CFLAGS="${LIBDCS_CORE_CFLAGS} `${PYTHON3_CONFIG} --includes`"
		LIBDCS_CORE_LIBS="${LIBDCS_CORE_LIBS} `${PYTHON3_CONFIG} --libs`"
		LIBDCS_CORE_LDFLAGS="${LIBDCS_CORE_LDFLAGS} `${PYTHON3_CONFIG} --ldflags`"
		enable_python_scripting=yes
	])

	pyoverridesdir="\$(pyexecdir)/gi/overrides"
	AC_SUBST(pyoverridesdir)
])


dnl ***********************************************************************
dnl Initialize Libtool
dnl ***********************************************************************
LT_PREREQ([2.2])
LT_INIT
LT_LIB_M


dnl ***********************************************************************
dnl Additional C Compiler Flags
dnl ***********************************************************************
AX_CHECK_COMPILE_FLAG([-Werror=unknown-warning-option], [
	ax_compiler_flags_test="-Werror=unknown-warning-option"
], [
	ax_compiler_flags_test=""
])
AX_APPEND_COMPILE_FLAGS([ \
	-Wall \
	-Wcast-align \
	-Wdeclaration-after-statement \
	-Wformat-security \
	-Werror=format=2 \
	-Wextra \
	-Wmissing-include-dirs \
	-Wnested-externs \
	-Wno-missing-field-initializers \
	-Wno-sign-compare \
	-Wno-strict-aliasing \
	-Wno-uninitialized \
	-Wno-unused-parameter \
	-Wpointer-arith \
	-Wpointer-sign \
	-Wredundant-decls \
	-Wshadow \
	-Wswitch-default \
	-Wswitch-enum \
	-Wundef \
], [], [$ax_compiler_flags_test])
AC_C_CONST


dnl ***********************************************************************
dnl Support for valadoc Documentation Engine
dnl ***********************************************************************
AC_ARG_ENABLE(doc,
	AS_HELP_STRING([--enable-doc],
		[Enable documentation generation]), enable_doc=$enableval,
	enable_doc=no)
AM_CONDITIONAL(ENABLE_DOC, test x$enable_doc = xyes)

AS_IF([test "x$enable_doc" != xno],
	[AC_PATH_PROG(VALADOC, valadoc, :)
	 AC_SUBST(VALADOC)
	 AS_IF([test "$VALADOC" = :],
		[AC_MSG_ERROR([valadoc not found])])])


dnl ***********************************************************************
dnl Setup Various Compiler Optimizations
dnl ***********************************************************************
AC_MSG_CHECKING([whether to enable optimized builds])
AC_ARG_ENABLE(optimizations,
              AC_HELP_STRING([--enable-optimizations],
                             [turn on build-time optimizations [default=yes]]),
              [enable_optimizations=$enableval],
              [AS_IF([test "x$enable_debug" = "xyes"],
		     [enable_optimizations="no"],
		     [enable_optimizations="yes"])])
AC_MSG_RESULT([$enable_optimizations])
OPTIMIZE_CFLAGS=""
OPTIMIZE_LDFLAGS=""
# Enable -Bsymbolic
AS_IF([test "$enable_optimizations" != "no"],
      [AX_CHECK_LINK_FLAG([-Wl,-Bsymbolic],
                          [OPTIMIZE_LDFLAGS="$OPTIMIZE_LDFLAGS -Wl,-Bsymbolic"])
       AX_CHECK_LINK_FLAG([-fno-plt],
                          [OPTIMIZE_LDFLAGS="$OPTIMIZE_LDFLAGS -fno-plt"])])
AC_SUBST(OPTIMIZE_CFLAGS)
AC_SUBST(OPTIMIZE_LDFLAGS)


dnl ***********************************************************************
dnl Check if we should instrument our targets
dnl ***********************************************************************
AC_MSG_CHECKING([for --enable-profiling])
AC_ARG_ENABLE(profiling,
              AC_HELP_STRING([--enable-profiling],
                             [turn on runtime instrumentation [default=no]]),
              [enable_profiling=$enableval],
	      [enable_profiling=no])
AS_IF([test "$enable_profiling" = "yes"],[
	ac_save_cflags="$CFLAGS"
	CFLAGS="$CFLAGS -pg"
	AC_LINK_IFELSE([AC_LANG_SOURCE([[int main() { return 0; }]])],
	               [PROFILING_CFLAGS="-pg"],
		       [enable_profiling=no])
	CFLAGS="$ac_save_cflags $PROFILING_CFLAGS"
])
AC_MSG_RESULT([$enable_profiling])


dnl ***********************************************************************
dnl Setup common cflags and ldflags for plugins
dnl ***********************************************************************
PLUGIN_CFLAGS="$PLUGIN_CFLAGS -I\$(top_srcdir)/src/libdcs-core"
PLUGIN_CFLAGS="$PLUGIN_CFLAGS -I\$(top_srcdir)/src/libdcs-net"
PLUGIN_CFLAGS="$PLUGIN_CFLAGS -I\$(top_srcdir)/src/libdcs-ui"
PLUGIN_CFLAGS="$PLUGIN_CFLAGS $LIBDCS_CORE_CFLAGS"
PLUGIN_CFLAGS="$PLUGIN_CFLAGS $LIBDCS_NET_CFLAGS"
PLUGIN_CFLAGS="$PLUGIN_CFLAGS $LIBDCS_UI_CFLAGS"
PLUGIN_CFLAGS="$PLUGIN_CFLAGS $DEBUG_CFLAGS"
PLUGIN_CFLAGS="$PLUGIN_CFLAGS $OPTIMIZE_CFLAGS"
AC_SUBST(PLUGIN_CFLAGS)

PLUGIN_LDFLAGS="$PLUGIN_LDFLAGS $OPTIMIZE_LDFLAGS"
PLUGIN_LDFLAGS="$PLUGIN_LDFLAGS -avoid-version"
dnl PLUGIN_LDFLAGS="$PLUGIN_LDFLAGS -export-symbols-regex peas_register_types"
PLUGIN_LDFLAGS="$PLUGIN_LDFLAGS -module"
AC_SUBST(PLUGIN_LDFLAGS)

PLUGIN_VALAFLAGS="$PLUGIN_VALAFLAGS --target-glib=2.44"
PLUGIN_VALAFLAGS="$PLUGIN_VALAFLAGS --thread"
PLUGIN_VALAFLAGS="$PLUGIN_VALAFLAGS --vapidir \$(top_srcdir)/vapi"
PLUGIN_VALAFLAGS="$PLUGIN_VALAFLAGS --vapidir \$(top_builddir)/src/libdcs-core"
PLUGIN_VALAFLAGS="$PLUGIN_VALAFLAGS --vapidir \$(top_builddir)/src/libdcs-net"
PLUGIN_VALAFLAGS="$PLUGIN_VALAFLAGS --vapidir \$(top_builddir)/src/libdcs-ui"
PLUGIN_VALAFLAGS="$PLUGIN_VALAFLAGS --pkg dcs-core-0.1"
PLUGIN_VALAFLAGS="$PLUGIN_VALAFLAGS --pkg dcs-net-0.1"
PLUGIN_VALAFLAGS="$PLUGIN_VALAFLAGS --pkg dcs-ui-0.1"
PLUGIN_VALAFLAGS="$PLUGIN_VALAFLAGS --pkg libpeas-1.0"
PLUGIN_VALAFLAGS="$PLUGIN_VALAFLAGS --pkg libpeas-gtk-1.0"
PLUGIN_VALAFLAGS="$PLUGIN_VALAFLAGS --pkg libzmq"
AC_SUBST(PLUGIN_VALAFLAGS)


dnl ***********************************************************************
dnl Setup common cflags and ldflags for devices
dnl ***********************************************************************
DEVICE_CFLAGS="$DEVICE_CFLAGS -I\$(top_srcdir)/src/libdcs-core"
DEVICE_CFLAGS="$DEVICE_CFLAGS -I\$(top_srcdir)/src/libdcs-daq"
DEVICE_CFLAGS="$DEVICE_CFLAGS -I\$(top_srcdir)/src/libdcs-net"
DEVICE_CFLAGS="$DEVICE_CFLAGS $LIBDCS_CORE_CFLAGS"
DEVICE_CFLAGS="$DEVICE_CFLAGS $LIBDCS_NET_CFLAGS"
DEVICE_CFLAGS="$DEVICE_CFLAGS $LIBDCS_DAQ_CFLAGS"
DEVICE_CFLAGS="$DEVICE_CFLAGS $DEBUG_CFLAGS"
DEVICE_CFLAGS="$DEVICE_CFLAGS $OPTIMIZE_CFLAGS"
AC_SUBST(DEVICE_CFLAGS)

DEVICE_LDFLAGS="$DEVICE_LDFLAGS $OPTIMIZE_LDFLAGS"
DEVICE_LDFLAGS="$DEVICE_LDFLAGS -avoid-version"
dnl DEVICE_LDFLAGS="$DEVICE_LDFLAGS -export-symbols-regex peas_register_types"
DEVICE_LDFLAGS="$DEVICE_LDFLAGS -module"
AC_SUBST(DEVICE_LDFLAGS)

DEVICE_VALAFLAGS="$DEVICE_VALAFLAGS --target-glib=2.44"
DEVICE_VALAFLAGS="$DEVICE_VALAFLAGS --thread"
DEVICE_VALAFLAGS="$DEVICE_VALAFLAGS --vapidir \$(top_srcdir)/vapi"
DEVICE_VALAFLAGS="$DEVICE_VALAFLAGS --vapidir \$(top_builddir)/src/libdcs-core"
DEVICE_VALAFLAGS="$DEVICE_VALAFLAGS --vapidir \$(top_builddir)/src/libdcs-daq"
DEVICE_VALAFLAGS="$DEVICE_VALAFLAGS --vapidir \$(top_builddir)/src/libdcs-net"
DEVICE_VALAFLAGS="$DEVICE_VALAFLAGS --pkg dcs-core-0.1"
DEVICE_VALAFLAGS="$DEVICE_VALAFLAGS --pkg dcs-daq-0.1"
DEVICE_VALAFLAGS="$DEVICE_VALAFLAGS --pkg dcs-net-0.1"
DEVICE_VALAFLAGS="$DEVICE_VALAFLAGS --pkg libpeas-1.0"
AC_SUBST(DEVICE_VALAFLAGS)


dnl ***********************************************************************
dnl Setup common cflags and ldflags for logging backends
dnl ***********************************************************************
BACKEND_CFLAGS="$BACKEND_CFLAGS -I\$(top_srcdir)/src/libdcs-core"
BACKEND_CFLAGS="$BACKEND_CFLAGS -I\$(top_srcdir)/src/libdcs-log"
BACKEND_CFLAGS="$BACKEND_CFLAGS -I\$(top_srcdir)/src/libdcs-net"
BACKEND_CFLAGS="$BACKEND_CFLAGS $LIBDCS_CORE_CFLAGS"
BACKEND_CFLAGS="$BACKEND_CFLAGS $LIBDCS_NET_CFLAGS"
BACKEND_CFLAGS="$BACKEND_CFLAGS $LIBDCS_LOG_CFLAGS"
BACKEND_CFLAGS="$BACKEND_CFLAGS $DEBUG_CFLAGS"
BACKEND_CFLAGS="$BACKEND_CFLAGS $OPTIMIZE_CFLAGS"
AC_SUBST(BACKEND_CFLAGS)

BACKEND_LDFLAGS="$BACKEND_LDFLAGS $OPTIMIZE_LDFLAGS"
BACKEND_LDFLAGS="$BACKEND_LDFLAGS -avoid-version"
dnl BACKEND_LDFLAGS="$BACKEND_LDFLAGS -export-symbols-regex peas_register_types"
BACKEND_LDFLAGS="$BACKEND_LDFLAGS -module"
AC_SUBST(BACKEND_LDFLAGS)

BACKEND_VALAFLAGS="$BACKEND_VALAFLAGS --target-glib=2.44"
BACKEND_VALAFLAGS="$BACKEND_VALAFLAGS --thread"
BACKEND_VALAFLAGS="$BACKEND_VALAFLAGS --vapidir \$(top_srcdir)/vapi"
BACKEND_VALAFLAGS="$BACKEND_VALAFLAGS --vapidir \$(top_builddir)/src/libdcs-core"
BACKEND_VALAFLAGS="$BACKEND_VALAFLAGS --vapidir \$(top_builddir)/src/libdcs-log"
BACKEND_VALAFLAGS="$BACKEND_VALAFLAGS --vapidir \$(top_builddir)/src/libdcs-net"
BACKEND_VALAFLAGS="$BACKEND_VALAFLAGS --pkg dcs-core-0.1"
BACKEND_VALAFLAGS="$BACKEND_VALAFLAGS --pkg dcs-log-0.1"
BACKEND_VALAFLAGS="$BACKEND_VALAFLAGS --pkg dcs-net-0.1"
BACKEND_VALAFLAGS="$BACKEND_VALAFLAGS --pkg libpeas-1.0"
AC_SUBST(BACKEND_VALAFLAGS)


dnl ***********************************************************************
dnl Process .in Files
dnl ***********************************************************************
AC_CONFIG_FILES([
	Makefile

	build/Makefile
	build/autotools/Makefile

	contrib/Makefile

	data/Makefile
	data/config/Makefile
	data/glade/Makefile
	data/icons/Makefile
	data/icons/16x16/Makefile
	data/icons/22x22/Makefile
	data/icons/24x24/Makefile
	data/icons/32x32/Makefile
	data/icons/48x48/Makefile
	data/icons/scalable/Makefile
	data/mime/Makefile
	data/org.opendcs.Dcsg.desktop.in

    data/systemd/Makefile
    data/systemd/dcs-ctl.service
    data/systemd/dcs-daq.service
    data/systemd/dcs-log.service

    data/templates/Makefile
    data/templates/common/Makefile
    data/templates/common/build/Makefile
    data/templates/common/build/autotools/Makefile
    data/templates/common/src/Makefile
    data/templates/backend/Makefile
    data/templates/backend/src/Makefile
    data/templates/device/Makefile
    data/templates/device/src/Makefile
    data/templates/plugin/Makefile
    data/templates/plugin/src/Makefile

    data/gsettings/Makefile
	data/gsettings/org.opendcs.dcs.gschema.xml

	doc/Makefile

	po/Makefile.in

	src/Makefile
	src/dcs/Makefile
	src/dcsg/Makefile
	src/dcs-analyze/Makefile
	src/dcs-daq/Makefile
	src/dcs-log/Makefile
	src/dcs-plugin/Makefile
	src/dcs-plugin/setup.cfg

	src/libdcs-core/Makefile
	src/libdcs-cli/Makefile
	src/libdcs-daq/Makefile
	src/libdcs-log/Makefile
	src/libdcs-net/Makefile
	src/libdcs-ui/Makefile
	src/libdcs-ui/extensions/Makefile

    src/backends/Makefile

	src/plugins/Makefile
	src/plugins/samples/Makefile

	src/devices/Makefile
	src/devices/samples/Makefile

	examples/Makefile
	examples/javascript/Makefile
	examples/python/Makefile
	examples/ruby/Makefile
	examples/vala/Makefile

	src/libdcs-core/dcs-core-0.1.pc
	src/libdcs-cli/dcs-cli-0.1.pc
	src/libdcs-daq/dcs-daq-0.1.pc
	src/libdcs-log/dcs-log-0.1.pc
	src/libdcs-net/dcs-net-0.1.pc
	src/libdcs-ui/dcs-ui-0.1.pc
])
AC_OUTPUT


AC_MSG_NOTICE([

    ${PACKAGE} ${VERSION}

    Options

     Prefix: ...................................... : ${prefix}
     Libdir: ...................................... : ${libdir}
     Optimized Build: ............................. : ${enable_optimizations}
     WebKit: ...................................... : ${enable_webkit}

    Development Options

     DAQ support: ................................. : ${with_cld}
     UI support: .................................. : ${with_ui}
     Enable Debug: ................................ : ${enable_debug}
     Enable Tracing: .............................. : ${enable_tracing}
     Enable Profiling (-pg): ...................... : ${enable_profiling}
     Build documentation: ......................... : ${enable_doc}
     Build API reference: ......................... : ${enable_doc}
     Update MIME Database: ........................ : ${enable_mime}

    Plugins

     (placeholder): ............................... : ${enable_placeholder_plugin}

    Backends

     XML: ......................................... : ${enable_xml_backend}

    Devices

     Arduino: ..................................... : ${enable_arduino_device}
     Comedi: ...................................... : ${enable_comedi_device}
     MCC USB: ..................................... : ${enable_mccusb_device}

    Example Plugins

     Example Python: .............................. : ${enable_python_plugin}
     Example Vala: ................................ : ${enable_vala_plugin}

    Languages support

     Python 3 support: ............................ : ${enable_python_scripting}

    $PACKAGE will be installed in ${bindir}
])
