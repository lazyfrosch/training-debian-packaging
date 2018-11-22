Using dh_make
=============

`dh_make` is a tool for quick-starting a new package.

## Extract sourcecode

First you need to get and extract the original source code of your software.

```
$ wget https://github.com/Icinga/icingaweb2/archive/v2.6.2.tar.gz
$ tar xf v2.6.2.tar.gz
$ mv icingaweb2-2.6.2 icingaweb2
```

Basically the extracted source tree can be named however you like, it is recommended to be either:

1. source package name, without any version, like `icingaweb2`
2. source package with version, in format `<source>_<upstreamversion>`, e.g. `icingaweb2_2.6.2` (please note underscore)

Now we switch to this directory and run `dh_make`:

```
$ cd icingaweb2/
$ dh_make -p icingaweb2_2.6.2 -f ../v2.6.2.tar.gz
```

* `-p` is necessary once here, when the directory is not in the `<source>_<upstreamversion>` format
* `-f` tells `dh_make` where to find the original tarball

This leaves you with a collection of defaults and examples:

```
$ ls -R  debian/
debian/:
changelog  copyright               icingaweb2-docs.docs  manpage.xml.ex  postrm.ex   README.Debian  source
compat     icingaweb2.cron.d.ex    manpage.1.ex          menu.ex         preinst.ex  README.source  watch.ex
control    icingaweb2.doc-base.EX  manpage.sgml.ex       postinst.ex     prerm.ex    rules

debian/source:
format
```

You should now browse the files and fill them with your information, and cleanup files you don't need!

In addition `dh_make` will copy the tarball to the `.orig.tar.gz` filename for Debian:

```
$ ls ../
icingaweb2  icingaweb2_2.6.2.orig.tar.gz  v2.6.2.tar.gz
```

## Native packages

`dh_make` can also get you started with native packages, so no original tarball exists.

This is mainly useful when the `debian/` directory will be included in the original sourcecode.

```
$ dh_make --native -p icingaweb2_2.6.2
```
