/**
 * Holds constants defined by the build system.
 */

[CCode (cheader_filename = "config.h")]
public class Dcs.Build {

    /* Package information */

    [CCode (cname = "PACKAGE_NAME")]
    public const string PACKAGE_NAME;

    [CCode (cname = "PACKAGE_STRING")]
    public const string PACKAGE_STRING;

    [CCode (cname = "PACKAGE_VERSION")]
    public const string PACKAGE_VERSION;

    [CCode (cname = "PACKAGE_DATADIR")]
    public const string PACKAGE_DATADIR;

    /* Gettext package */

    [CCode (cname = "GETTEXT_PACKAGE")]
    public const string GETTEXT_PACKAGE;

    [CCode (cname = "LOCALEDIR")]
    public const string LOCALEDIR;

    /* Configured paths - these variables are not present in config.h, they are
     * passed to underlying C code as cmd line macros. */

    [CCode (cname = "DATADIR")]
    public const string DATADIR;

    [CCode (cname = "SYS_CONFIG_DIR")]
    public const string SYS_CONFIG_DIR;

    [CCode (cname = "PLUGIN_DIR")]
    public const string PLUGIN_DIR;

    [CCode (cname = "UI_DIR")]
    public const string UI_DIR;

    [CCode (cname = "WEB_EXTENSION_DIR")]
    public const string WEB_EXTENSION_DIR;

    [CCode (cname = "DEVICE_DIR")]
    public const string DEVICE_DIR;

    [CCode (cname = "BACKEND_DIR")]
    public const string BACKEND_DIR;

    [CCode (cname = "CONTROLLER_DIR")]
    public const string CONTROLLER_DIR;

    [CCode (cname = "LIBDIR")]
    public const string LIBDIR;

    [CCode (cname = "TMPLDIR")]
    public const string TMPLDIR;
}
