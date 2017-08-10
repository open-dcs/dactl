![OpenDCS Logo][logo]

# OpenDCS - Distributed Control System Components
[![Documentation Status](https://readthedocs.org/projects/dactl/badge/?version=latest)](https://readthedocs.org/projects/dactl/?badge=latest)
[![Build Status](https://travis-ci.org/open-dcs/dcs.svg)](https://travis-ci.org/open-dcs/dcs)
[![Coverage Status](https://coveralls.io/repos/github/open-dcs/dcs/badge.svg?branch=master)](https://coveralls.io/github/open-dcs/dcs?branch=master)

For the website associated with this project visit [here][gh-pages].

## Description

OpenDCS is a set of services and applications for creating custom data
acquisition and control systems in a distributed manner. The target operating
system is Linux and depends on GNOME libraries and utilities.

### Release 0.3

The current public release is a beta release that is a fork of
[dactl](https://github.com/coanda/dactl) and probably won't be in a usable
state until at least the next minor release. The libraries include GIR output
for use in other languages, the support of which is still a work in progress.

### Building

OpenDCS is built using meson:

```bash
meson _build
ninja -C _build
sudo ninja -C _build install
```

<!--
### Installation Instructions:

Instructions for installing OpenDCS and it's dependencies can be read
[here](https://dactl.readthedocs.org/en/latest/setup.html).
-->

[logo]: https://open-dcs.github.io/assets/img/dcs.svg "OpenDCS Logo"
[gh-pages]: https://open-dcs.github.io/ "OpenDCS Pages"
