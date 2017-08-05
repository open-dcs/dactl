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

#ifndef CONFIG_H_INCLUDED
#include "config.h"

/**
 * All this is to keep Vala happy & configured..
 */
const char *DCS_DATADIR = PACKAGE_DATADIR;
const char *DCS_VERSION = PACKAGE_VERSION;
const char *DCS_WEBSITE = PACKAGE_URL;
const char *DCS_LOCALEDIR = LOCALEDIR;
const char *DCS_GETTEXT_PACKAGE = GETTEXT_PACKAGE;
/*
 *const char *DCS_CONFDIR = SYSCONFDIR;
 */

const char *DCS_BACKEND_DIR = BACKEND_DIR;
const char *DCS_BACKEND_CONF_DIR = BACKEND_CONF_DIR;
const char *DCS_BACKEND_DATA_DIR = BACKEND_DATA_DIR;

const char *DCS_CONTROLLER_DIR = CONTROLLER_DIR;
const char *DCS_CONTROLLER_CONF_DIR = CONTROLLER_CONF_DIR;
const char *DCS_CONTROLLER_DATA_DIR = CONTROLLER_DATA_DIR;

const char *DCS_DEVICE_DIR = DEVICE_DIR;
const char *DCS_DEVICE_CONF_DIR = DEVICE_CONF_DIR;
const char *DCS_DEVICE_DATA_DIR = DEVICE_DATA_DIR;

const char *DCS_PLUGIN_DIR = PLUGIN_DIR;
const char *DCS_PLUGIN_CONF_DIR = PLUGIN_CONF_DIR;
const char *DCS_PLUGIN_DATA_DIR = PLUGIN_DATA_DIR;

#else
#error config.h missing!
#endif
