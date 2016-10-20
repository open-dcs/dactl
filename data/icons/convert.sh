#!/bin/bash

inkscape --shell <<COMMANDS
  --export-png "16x16/dcs.png" -w 16 "scalable/dcs.svg"
  --export-png "22x22/dcs.png" -w 22 "scalable/dcs.svg"
  --export-png "24x24/dcs.png" -w 24 "scalable/dcs.svg"
  --export-png "32x32/dcs.png" -w 32 "scalable/dcs.svg"
  --export-png "48x48/dcs.png" -w 48 "scalable/dcs.svg"
quit
COMMANDS
