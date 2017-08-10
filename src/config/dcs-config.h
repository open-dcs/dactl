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

#ifndef _DCS_CONFIG_H_
#define _DCS_CONFIG_H_

extern const char *DCS_MODULE_DIRECTORY;

extern const char *DCS_MODULE_DATA_DIRECTORY;

/* i.e. /usr/share/ */
extern const char *DCS_DATADIR;

extern const char *DCS_VERSION;

extern const char *DCS_WEBSITE;

extern const char *DCS_NAME;

extern const char *DCS_STRING;

extern const char *DCS_LOCALEDIR;

extern const char *DCS_GETTEXT_PACKAGE;

/* /etc/dcs */
extern const char *DCS_CONFDIR;

/* i.e. /usr/lib64/dcs/backends */
extern const char *DCS_BACKEND_DIR;

/* i.e. /etc/dcs/backend */
extern const char *DCS_BACKEND_CONF_DIR;

/* i.e. /usr/share/dcs/backend */
extern const char *DCS_BACKEND_DATA_DIR;

extern const char *DCS_CONTROLLER_DIR;

extern const char *DCS_CONTROLLER_CONF_DIR;

extern const char *DCS_CONTROLLER_DATA_DIR;

extern const char *DCS_DEVICE_DIR;

extern const char *DCS_DEVICE_CONF_DIR;

extern const char *DCS_DEVICE_DATA_DIR;

extern const char *DCS_PLUGIN_DIR;

extern const char *DCS_PLUGIN_CONF_DIR;

extern const char *DCS_PLUGIN_DATA_DIR;

/* /usr/lib/dcs/templates */
extern const char *DCS_TEMPLATE_DIR;

/* /usr/lib/dcs/extensions */
extern const char *DCS_WEB_EXTENSION_DIR;

#endif
