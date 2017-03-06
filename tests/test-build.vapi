/**
 * Holds constants defined by the build system.
 */

[CCode (cheader_filename = "config.h")]
public class Dcs.Test.Build {
    /* Configured paths - these variables are not present in config.h, they are
     * passed to underlying C code as cmd line macros. */
    [CCode (cname = "CONFIG_DIR")]
    public static const string CONFIG_DIR;
}
