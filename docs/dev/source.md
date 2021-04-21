Source Package
==============

Unlike RPM sources a Debian source package consists of multiple files.

## Downloading a source

When you have configured `deb-src` packages in your [APT sources](../admin/repositories.md) you can download sources.

Please make sure you are in a proper working directory, since this downloads multiple files.

    mkdir debian-packages
    cd debian-packages/

    apt source icingaweb2

You can see APT downloading multiple files from the repository, and verifying them against the [Debian Developer Keyring]
which contains all developer GPG keys, since the source package is signed by the individual developer.

    Reading package lists... Done
    NOTICE: 'icingaweb2' packaging is maintained in the 'Git' version control system at:
    https://salsa.debian.org/nagios-team/pkg-icingaweb2.git
    Please use:
    git clone https://salsa.debian.org/nagios-team/pkg-icingaweb2.git
    to retrieve the latest (possibly unreleased) updates to the package.
    Need to get 8.180 kB of source archives.
    Get:1 http://cdn-fastly.deb.debian.org/debian buster/main icingaweb2 2.6.1-1 (dsc) [2.361 B]
    Get:2 http://cdn-fastly.deb.debian.org/debian buster/main icingaweb2 2.6.1-1 (tar) [8.165 kB]
    Get:3 http://cdn-fastly.deb.debian.org/debian buster/main icingaweb2 2.6.1-1 (diff) [12,2 kB]
    Fetched 8.180 kB in 14s (590 kB/s)
    dpkg-source: info: extracting icingaweb2 in icingaweb2-2.6.1
    dpkg-source: info: unpacking icingaweb2_2.6.1.orig.tar.gz
    dpkg-source: info: unpacking icingaweb2_2.6.1-1.debian.tar.xz

**Note:** While this method is very good for reverse engineering, or rebuilding a package, most workflows today are
based on [GIT tools](#git-tools). You can also see a notice in the output above.

If a download could not be verified, for example when it is from a third party repository or contributor, you can
manually extract the downloaded files. (APT will suggest this as well)

    dpkg-source --no-check -x icingaweb2_2.6.1-1.stretch.dsc

**Lab:** Download `icingaweb2` or another source package and extract it.

## Source package format

A few files build the Debian source packages, which is created on build, and uploaded to a repository.

* `package_1.0.0-1.dsc` is the meta data description file for the source, which also includes the signature
* `package_1.0.0-1.debian.tar.xz` contains the Debian packaging files (whats inside the `debian/` directory)
* `package_1.0.0.orig.tar.gz` is the original tarball or source distribution from upstream

**Lab:** Have a look in the DSC file and check its content.

## Versioning

The Debian package versions can describe
exact state of the package pretty detailed.

**Simple example:** `1.0.0-1`

* Upstream version: `1.0.0`
* Debian revision: `1`

**Complex examples:**

    2.1.4-2.1+deb8u7

    Upstream: 2.1.4
    Revision: 2.1 (the dot signals non-maintainer upload)
    Special: +deb8u7 (Release tag for a stable update)

Also there is a "native" format, which means that the package does not have a revision since it is a native Debian
tool, e.g. devscripts, dpkg.

Versions also can have special operators, which are explained in the
[Debian Policy on Version](https://www.debian.org/doc/debian-policy/ch-controlfields.html#s-f-version).

## Extracted source format

In the extracted format, a source package is basically the full program source extracted, plus the `debian/` directory.
Which contains all definitions and patches for Debian.

If the package is not a native package, the dpkg tools need the source tarball to verify and a clean source directory.

All work happens in this extracted format, where at least a source package is built from. Various file and directories
can be included in this directory, also custom stuff that later is included in packages or just kept for documentation.

### `control`

Main metadata file which defines:

* Source name
* Maintainer
* Binary packages
* Dependencies and other relations
* Descriptions

See [man deb-control].

### `changelog`

History of the package, and the released versions. This defines the **current version**.

See [man deb-changelog].

### `rules`

Is a makefile that is called on build to execute the various build steps. For details see [man dpkg-buildpackage].

The most basic content leaves all for [debhelper] to figure out.

    #!/usr/bin/make -f
    #export DH_VERBOSE=1

    %:
            dh $@

Also see [man dpkg-src-rules].

### `source/format`

Defines which source format to expect, there are legacy versions, but usually this is one of:

* `3.0 (quilt)`
* `3.0 (native)`

The word `quilt` describes a patch tool.

### `compat` / `debhelper-compat`

The file `compat` defines the feature compatibility version for [debhelper], this mostly is important when using newer
features, or when you want to backport a package to an older Debian release. It just contains the major version, e.g. `9`.

In recent versions of debhelper, it is now recommended avoiding `compat`, and instead use a `debhelper-compat`
build dependency in the `control` file.

    Build-Depends: debhelper-compat (= 13)

See the [debhelper] manpage for details.

### `copyright`

For Debian this is very important, since it describes the license information for all contents of the source and the
packaging related files, in a central location.

This should be in [machine readable format](https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/).

### `install`

Also: `<package>.install`

Describes where to install certain files to the package from various path:

* Files installed by `dh_auto_install` under `debian/tmp/`
* From the source directory

Similar files exist:

* `dirs` - directories to create empty
* `links` - symlink to create
* `docs` - files to install under `/usr/share/doc/<package>`

### `post` and `pre` scripts

Custom scripts can be put here under: `*.post*|*.pre*`

Those scripts are run during certain steps of dpkg bringing packages onto your target system, like:

* Stopping and Starting services
* Configuring users, permissions and other files

Sometimes debhelper creates or extend those files, so you might see a `##DEBHELPER##` tag in some examples.

Please see [man dpkg] and

### `patches/`

Can contain multiple patches that are applied during build. Patches are put here and mentioned in order in the `series`
file.

[dep3](https://dep-team.pages.debian.net/deps/dep3/) also describes optional metadata for patches.

### `watch`

The watch file is a helper file for [uscan], to automatically check and download available versions of the software.

Debian uses this to check for new versions, but you can often use it to also download a tarball.

### Other files

Other files can exist and vary in format, the are used by a specify [debhelper] add-on.

**Lab:** Browse the files of your package and find the following information:

* Current version, who changed the package?
* What are the build dependencies?
* What binary packages are built?

## Build systems

[debhelper] builds on other build systems like:

* configure/make
* cmake
* Golang
* Python `setuptools`
* Ruby Gem
* etc.

Where certain steps are common and often need to be configured:

* `dh_auto_configure` which configures the source code for a build (e.g. `./configure` or `cmake .. -Dxx`)
* `dh_auto_build` that runs the build (e.g. `make`)
* `dh_auto_install` that install files in a target path (e.g. `make install`)

There are manpages for every [debhelper] tool under `dh_*`.

## Single vs. Multi-Binary

If a source only contains a simple binary some path handling is simplified. So files installed by the build tools are
directly put into the package.

While in a multi-binary layout, the files are put into a `tmp/` path, before files a selectively
installed by `install` files.

## Git tools

Nowadays most Debian source definitions are stored in GIT repositories. Nearly all source packages
have metadata like this:

    Vcs-Browser: https://salsa.debian.org/nagios-team/pkg-icingaweb2
    Vcs-Git: https://salsa.debian.org/nagios-team/pkg-icingaweb2.git

When using GIT there are tools like [git-buildpackage] that help with checkout, branching, import and changelog.

You can checkout this repository, which also includes a branch and tags for upstream. Upstream code is updated with
a single commit, and merged to the master branch, which adds files under `debian/`.

**Lab:**

* Have a look on the icingaweb2 repository and its branches and tags
* See how older versions in the changelog have git hashes

[Debian Developer Keyring]: https://packages.debian.org/stable/debian-keyring
[debhelper]: https://manpages.debian.org/testing/dpkg-dev/debhelper.5.html
[man deb-control]: https://manpages.debian.org/testing/dpkg-dev/deb-control.5.html
[man deb-changelog]: https://manpages.debian.org/testing/dpkg-dev/deb-changelog.5.html
[man dpkg-buildpackage]: https://manpages.debian.org/testing/dpkg-dev/dpkg-buildpackage.5.html
[git-buildpackage]: https://wiki.debian.org/PackagingWithGit
[man dpkg-src-rules]: https://manpages.debian.org/testing/dpkg-dev/deb-src-rules.5.html
[man dpkg]: https://manpages.debian.org/testing/dpkg/dpkg.1.html
[uscan]: https://manpages.debian.org/testing/devscripts/uscan.1.html
