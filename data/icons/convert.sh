#!/bin/bash

inkscape --shell <<COMMANDS
  --export-png "hicolor/16x16/apps/org.opendcs.Dcsg.png" -w 16 "scalable/apps/opendcs.svg"
  --export-png "hicolor/24x24/apps/org.opendcs.Dcsg.png" -w 24 "scalable/apps/opendcs.svg"
  --export-png "hicolor/32x32/apps/org.opendcs.Dcsg.png" -w 32 "scalable/apps/opendcs.svg"
  --export-png "hicolor/48x48/apps/org.opendcs.Dcsg.png" -w 48 "scalable/apps/opendcs.svg"
  --export-png "hicolor/256x256/apps/org.opendcs.Dcsg.png" -w 256 "scalable/apps/opendcs.svg"
  --export-png "hicolor/512x512/apps/org.opendcs.Dcsg.png" -w 512 "scalable/apps/opendcs.svg"
quit
COMMANDS
