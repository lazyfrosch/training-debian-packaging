APT Repositories
================

All packages APT downloads and installs are coming from APT repositories.

## Key Management and Security

For security and trust purposes all repositories should be signed with a GPG key.

This building a trust chain, where the administrator needs to add the public key to the local trust store,
so that all meta data and packages downloaded can be verified against that trust store.

    apt-key list

**You should see:**

* Keyrings installed by packages (e.g. `/etc/apt/trusted.gpg.d/debian-archive-stretch-stable.gpg`)
* Optional keys in the local trust store `/etc/apt/trusted.gpg`

You can also inspect the keyring packages:

    dpkg -l "*keyring*"
    dpkg -L debian-archive-keyring

Most repositories should offer a installation script, or direct instructions where to download and add the key.

Here is the [Icinga example for Debian](https://packages.icinga.com/debian/):

    wget -O - https://packages.icinga.com/icinga.key | sudo apt-key add -
    # or
    curl https://packages.icinga.com/icinga.key | sudo apt-key add -

**Note:** In contrast to RPM packages, Debian packages are not individually signed, the repository is signed.

## Configured repositories

Active repositories are configured inside `/etc/apt` in two ways:

* `sources.list` will contain the basic repositories for your Debian system
* `sources.list.d/*.list` can provide additional repositories

**Note:** Please do not add custom repositories to `sources.list`, add a new file.

Example of a default `sources.list`:

    deb http://deb.debian.org/debian stretch main
    deb http://security.debian.org/debian-security stretch/updates main
    deb http://deb.debian.org/debian stretch-updates main

Syntax of the lines:

* `deb` (binary packages) or `deb-src` (source packages)
* URL to access the repository
* Release (or suite)
* Components of the repository (e.g. `main` `non-free` `contrib`)

To add a custom repository you can just add a new file:

    sudo vim /etc/apt/sources.list.d/icinga.list
    deb http://packages.icinga.com/debian icinga-stretch main
    deb-src http://packages.icinga.com/debian icinga-stretch main

    sudo apt update

    sudo apt show icinga2

Repositories can also be in "simple" Format:

    deb file:///tmp/debian ./

## Repository layout

This is a pretty complex topic, so we are just touching the basics.

Each repository has a base URL: `https://deb.debian.org/debian`, this URL can be a CDN,
or a local mirror of the repository (e.g. `http://ftp.de.debian.org/debian/`).

On the repository any additional file can exist, what APT is looking for is this directory structure:

    dists/
    dists/<release>/                                  # release would be: stretch, stable, etc.
    dists/<release>/Release                           # main metadata and checksums for all files
    dists/<release>/Release.gpg                       # signature for the metadata
    dists/<release>/<component>/                      # component would be: main, contrib, non-free
    dists/<release>/<component>/Contents-<arch>.gz    # arch would be: amd64, i386
    dists/<release>/<component>/binary-all/           # arch independent packages (no binary programs)
    dists/<release>/<component>/binary-<arch>/
    dists/<release>/<component>/binary-*/Packages.gz  # meta data for all packages included
    dists/<release>/<component>/source/Sources.gz     # meta data for all source packages included

Various other metadata is included in these directories and then references by other files.

The main trust-root comes from `Release.gpg`, which signs `Release`,
all other files are referenced by checksum from there.

Outside of `dists/` it is most common to put the actual packages into `pool/`, the structure here depends on the
repository software used, files are references by URL and checksum from the metadata.

**Task:** Go to a repository and explore:

* http://ftp.de.debian.org/debian/dists/stretch/
* http://ftp.de.debian.org/debian/pool/

## Further reading

* [man apt-secure](https://manpages.debian.org/testing/apt/apt-secure.8.en.html)
* [man sources.list](https://manpages.debian.org/testing/apt/sources.list.5.en.html)
