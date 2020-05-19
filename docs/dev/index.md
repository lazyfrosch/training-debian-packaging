Development Environment
=======================

## Installing the basics

To start development on packages you need to not install package specific dependencies, but also the general toolset
for Debian packages.

    sudo apt install devscripts dpkg-dev build-essential dh-make debhelper

### `devscripts`

Includes various CLI tools to work with and manipulate a source package, see the description for more details:

    apt show devscripts

### `dpkg-dev`

Brings the `dpkg-*` tools to actually build and assemble the packages,
this is installed automatically as dependency of `devscripts`.

### `debhelper`

Since `dpkg-dev` only contains the very basic toolset, `debhelper` brings are lot of automation and simplification
to the build process. And avoids you taking care about everything.

Just look for `dh_*` manpages.

### `build-essential`

Depends on the most basic build tools, like `make` or `gcc`, which you will need for the most Unix sources.

### `dh-make`

An optional add-on for quick-starting Debian packages, so to have a basic boilerplate to start with packaging.

## Online Resources

Various online resources exist to help you research and find details on packages.

* [Tracker](https://tracker.debian.org/) Central search and information base for source packages
  * Including: history, versions, bugs, security info and links to sources and other tools
* [Debian GitLab](https://salsa.debian.org)

Please also see the [online resources in the Admin Guide](../admin/index.md#online-resources).
