# General

* Copy Budgie Desktop idea of a separate /idea repo and redirect this to that

# Build

* Add build to data/gsettings
* Install example configurations from data/config
* Add build to data/mime
* Install service site pages from data/services
* Decide whether to fix or remove data/systemd
* Add build for man pages
* Add build for examples
* Add build for unit tests
* Add build install for vapi
* Fix pkg-config output files for libs, currently not being configured
* Add GIR output from libdcs

# Configuration

* Fix half assed sample configs and rename to `whatever.xml.example`
* Get rid of XML
* Simplify Serialization/Deserialization using JSON Serializable

# Services

* Use Valum for REST routing
* Add proxy service to forward eg. `/api/daq/object` to DAQ service `api/object`
* Add web service (use Vue.js?)
* Add configuration service
* Allow config to come from URI to construct through file or service response
* Consider combining DAQ/Log/Control into single service

## Data Acquisition

## Feedback Control

## Logging

# Applications

## DCS Command Line Utility

## DCS GUI

* Finish switching to new Peas system for plugins
* Add UxManagerAddin for plugins
* Add TopbarProvider for plugins
* Add Notifications bar
* Add NotificationsProvider for plugins
* Switch graphs to what's provided by [libdazzle](https://github.com/chergert/libdazzle)

# Examples

* Add a C example
* Add a Perl example
* Add a Python example
* Add a Rust example
* Add a GJS example
* Add examples to illustrate every major API component

# Tests

* Add new tests that evaluate major sections of concepts
* Break tests into simpler approach used in eg. [icd](https://github.com/geoffjay/icd)
