/*
 * This file is part of OpenDCS
 *
 * Copyright (C) 2017 Geoff Johnson <geoff.jay@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

namespace Dcs {
    [CCode (cheader_filename = "dcs-config.h")]
    public extern const string DATADIR;

    /*
     *[CCode (cheader_filename = "dcs-config.h")]
     *public extern const string CONFDIR;
     */

    [CCode (cheader_filename = "dcs-config.h")]
    public extern const string VERSION;

    [CCode (cheader_filename = "dcs-config.h")]
    public extern const string WEBSITE;

    [CCode (cheader_filename = "dcs-config.h")]
    public extern const string GETTEXT_PACKAGE;

    [CCode (cheader_filename = "dcs-config.h")]
    public extern const string LOCALEDIR;

    [CCode (cheader_filename = "dcs-config.h")]
    public extern const string BACKEND_DIR;

    [CCode (cheader_filename = "dcs-config.h")]
    public extern const string BACKEND_CONF_DIR;

    [CCode (cheader_filename = "dcs-config.h")]
    public extern const string BACKEND_DATA_DIR;

    [CCode (cheader_filename = "dcs-config.h")]
    public extern const string CONTROLLER_DIR;

    [CCode (cheader_filename = "dcs-config.h")]
    public extern const string CONTROLLER_CONF_DIR;

    [CCode (cheader_filename = "dcs-config.h")]
    public extern const string CONTROLLER_DATA_DIR;

    [CCode (cheader_filename = "dcs-config.h")]
    public extern const string DEVICE_DIR;

    [CCode (cheader_filename = "dcs-config.h")]
    public extern const string DEVICE_CONF_DIR;

    [CCode (cheader_filename = "dcs-config.h")]
    public extern const string DEVICE_DATA_DIR;

    [CCode (cheader_filename = "dcs-config.h")]
    public extern const string PLUGIN_DIR;

    [CCode (cheader_filename = "dcs-config.h")]
    public extern const string PLUGIN_CONF_DIR;

    [CCode (cheader_filename = "dcs-config.h")]
    public extern const string PLUGIN_DATA_DIR;
}
