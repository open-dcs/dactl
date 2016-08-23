#!/bin/bash

SESSION=org.opendcs.Dcs.UI.Manager
PATH="/org/opendcs/dcs/ui/manager"

function dbus_call {
    _s=$1
    _p=$2
    _m=$_s.$3
    _d=$4

    if [ -n "$_d" ]; then
        echo $_d
        /usr/bin/gdbus call --session \
            --dest $_s \
            --object-path $_p \
            --method $_m \
            "$_d"
    else
        /usr/bin/gdbus call --session \
            --dest $_s \
            --object-path $_p \
            --method $_m
    fi
}

read -r -d '' JSON << EOM
{
  'type': 'DcsUIWindow',
  'properties': {
    'dest': '',
    'id': 'win0'
  },
  'objects': [{
    'type': 'DcsPage',
      'properties': {
        'dest': 'win0',
        'id': 'pg1',
      },
      'objects': [{
        'type': 'DcsBox',
        'properties': {
          'dest': 'pg1',
          'id': 'box0',
          'orientation': 'horizontal'
        }
      }]
    }
  }]
}
EOM

#dbus_call $SESSION $PATH "AddWidget" "$JSON"

dbus_call $SESSION $PATH "AddWidget" "{ 'type': 'DcsUIWindow', 'properties': { 'dest': '', 'id': 'win0' } }"

#dbus_call $SESSION $PATH "ListPages"
dbus_call $SESSION $PATH "AddWidget" "{ 'type': 'DcsPage', 'properties': { 'dest': 'win0', 'id': 'pg1' } }"
dbus_call $SESSION $PATH "AddWidget" "{ 'type': 'DcsBox', 'properties': { 'dest': 'pg1', 'id': 'box0', 'orientation': 'horizontal' } }"
dbus_call $SESSION $PATH "AddWidget" "{ 'type': 'DcsBox', 'properties': { 'dest': 'box0', 'id': 'box0-0', 'orientation': 'vertical' } }"
dbus_call $SESSION $PATH "AddWidget" "{ 'type': 'DcsBox', 'properties': { 'dest': 'box0', 'id': 'box0-1', 'orientation': 'vertical' } }"
dbus_call $SESSION $PATH "AddWidget" "{ 'type': 'DcsUIRichContent', 'properties': { 'dest': 'box0-1', 'id': 'rc0', 'uri': 'http://10.0.2.2/~gjohn/dev/dcs/' } }"
#dbus_call $SESSION $PATH "ListPages"
