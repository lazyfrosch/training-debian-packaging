Building packages
=================

In the [source package](source.md) chapter we learned what is inside a source.

This chapter explains how to build a package. All building is done with tools around [dpkg-buildpackage], for
example there is [debuild].

## Build requirements

You can install the build dependencies via APT. This is helpful when you need to re-build a package or want to make
small modifications.

    sudo apt build-dep icingaweb2

When there are different dependencies in the next package version, you either need to install them manually, or use
advanced helpers like [pbuilder-satisfydepends](https://wiki.ubuntu.com/PbuilderHowto). (WARNING: This is meant for
chroot builds)

## Build a package

Since we already have a source tree we can just build the current package:

    debuild

Every build cleans up the build tree to start the build from scratch.

**Lab:** Let's run the build and check the build log about what is happening.

**Bonus:** Add `export DH_VERBOSE=1` to the top of `rules` to have a detailed log

## Build output

After the build certain files are created in the parent directory.

* `<package>*_<version>.deb` - the Debian binary packages
* Files as describes in [Source Package](source.md)
* `<source>_<version>_<arch>.changes` Metadata for the finished build and upload
* `<source>_<version>_<arch>.build` Log of the build
* `<source>_<version>_<arch>.buildinfo` Extended metadata for the build

## Inspecting build

Inside the source tree you will find the typical build artifacts and binaries like in a normal sourcecode build.

But also inside the `debian/` directory, you will find new files and directories:

* `tmp/` - temporary filetree installed by `dh_auto_install`
* `<package>/` - filetree for every package
* `<package>.substvars` - replacement variables for `control`
* `<package>.debhelper.log` - log which debhelper tools have been run for this package

Also the built binary package files can be inspected and even extracted without actually installing
them by using [dpkg-deb].

    dpkg-deb -c icingacli_2.6.1-1_all.deb
    dpkg-deb -I icingacli_2.6.1-1_all.deb

    mkdir test/
    dpkg-deb -R icingacli_2.6.1-1_all.deb test/

**Lab:** Browse the directories under `debian/` and have a look inside the built binaries

## Update changelog

After changing packaging you always have to record that in `changelog`. It not only defines the version, but should
contain useful short information about what was done.

Every changelog entry contains:

* Source packages
* Version
* Target distribution (you will mostly see unstable and experimental here - UNRELEASED is for an incomplete changelog)
* Update priority (used for repository management in Debian)
* List of changes in text form
* Line signature with timestamp, developer name and e-mail

To make this simple tools like [dch] and [gbp-dch] help.

    dch # spawns an editor
    dch -a "I changed feature X" # adds a new line to the current entry
    dch -v 1.1.0-1 "Updated to 1.1.0" # make a new release version

You can always manually edit the file, as long as you keep the basic format.

## Signing and changes

When a build is finished the `.dsc` and `.changes` files will be signed by a developer. Those file contains checksums
for all included files.

With upload tools like [dput-ng] the changes and all dependent files can be uploaded to a repository.

Most repositores build trust on the signature and will apply a certain release mechanism.

[dpkg-buildpackage]: https://manpages.debian.org/testing/dpkg-dev/dpkg-buildpackage.5.html
[dpkg-deb]: https://manpages.debian.org/testing/dpkg/dpkg-deb.1.html
[debuild]: https://manpages.debian.org/testing/devscripts/debuild.1.html
[dch]: https://manpages.debian.org/testing/devscripts/dch.1.html
[gbp-dch]: https://manpages.debian.org/testing/git-buildpackage/gbp-dch.1.html
[dput-ng]: https://manpages.debian.org/stretch/dput-ng/dput.1.en.html
