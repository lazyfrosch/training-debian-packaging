Lintian
=======

Lintian is a toolkit for linting Debian packages from the contents of the `debian` directory. Normally Lintian is just run from the extract source, and look for built files.

An example for the [icingaweb2 package repository](https://salsa.debian.org/nagios-team/pkg-icingaweb2).
```
$ gbp buildpackage
$ lintian
N: Using profile debian/main.
N: Starting on group icingaweb2/2.7.3-2
N: Unpacking packages in group icingaweb2/2.7.3-2
N: Finished processing group icingaweb2/2.7.3-2
N: ----
N: Processing changes file icingaweb2
N: (version 2.7.3-2, arch source) ...
N: ----
N: Processing source package icingaweb2
N: (version 2.7.3-2, arch source) ...
N: ----
N: Processing buildinfo package icingaweb2
N: (version 2.7.3-2, arch source) ...
W: icingaweb2 source: changelog-should-mention-nmu
W: icingaweb2 source: source-nmu-has-incorrect-version-number 2.7.3-2
P: icingaweb2 source: package-uses-old-debhelper-compat-version 12
P: icingaweb2 source: rules-requires-root-missing
P: icingaweb2 source: source-contains-prebuilt-javascript-object public/js/vendor/jquery-3.4.1.min.js
P: icingaweb2 source: source-contains-prebuilt-javascript-object public/js/vendor/jquery-migrate-3.1.0.min.js
P: icingaweb2 source: source-contains-prebuilt-javascript-object public/js/vendor/jquery.sparkline.min.js
N: 1 tag overridden (1 info)
```

For more details and explanations, see the full output:

```
$ lintian --info --display-level pedantic --verbose
```

## Further reading

* [man lintian](https://manpages.debian.org/unstable/lintian/lintian.1.en.html)
* [Debian maintainer guide about lintian](https://www.debian.org/doc/manuals/maint-guide/checkit.en.html#lintians)
