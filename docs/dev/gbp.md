git-buildpackage
================

Most modern Debian packages are managed with GIT repositories, where at least the packaging is versioned in GIT, and
releases are usually also marked by GIT tags.

## Salsa

A while ago Debian established GitLab as a central hosting service for all GIT repositories. The service is just named
Salsa, and is available to everyone to join and contribute.

[`salsa.debian.org`](https://salsa.debian.org)

## Repository layouts

### Simple layout

A simple GIT repositories will just contain the `debian` directory, plus maybe some CI and metadata to build with.
In this mode you should find a very simple `master` or `debian/master` branch, can just clone it via `git`. But you
will need to take care of downloading and extracting source code.

This is also used for the [Linux Kernel package](https://salsa.debian.org/kernel-team/linux), which only does a simple
layout, because it is easier to handle in terms of repository sizes.

### Upstream branches

Many other repositories include the full source code of the upstream project, so it is easier for a developer to have
a full working environment.

In this usage case, the upstream source code is imported under branch `upstream`, or even the original upstream GIT
repository is used as base, with its branches like `master`. When importing upstream releases, GIT changes will only
show a single commit for the version, with added GIT tag.

To have the full file tree, there also will be a `debian/master` or `master` branch, which includes the `debian`
directory. Upstream changes are then merged to the Debian packaging branch.

As a result, after a GIT clone, you can just start building, and all file changes can be diffed against GIT.

The [icingaweb2 package repository](https://salsa.debian.org/nagios-team/pkg-icingaweb2) is a good example for this
usage style.

### pristine-tar

As optional add-on you often find a `pristine-tar` branch, this branch is used to store metadata, so the original
tarball can be recreated from the GIT branches.

Please see [`man pristine-tar`](https://manpages.debian.org/unstable/pristine-tar/pristine-tar.1.en.html) for details.

## git-buildpackage

Now Debian introduced a small toolkit to work with GIT repositories as source for Debian packages, helping with tasks
like:

* Cloning a GIT repository (with all gbp related branches)
* Pulling and pushing changes, across multiple branches
* Building the package while checking with GIT
* Updating changelog from GIT commits
* Importing / exporting tarballs of upstream

When building a package with `gbp`, the upstream tarball is usually created automatically.

## Examples

Cloning a repository:

```
$ gbp clone https://salsa.debian.org/nagios-team/pkg-icingaweb2 icingaweb2
$ cd icinga2/
```

You will see that multiple branches have been checked out, and will be updated by pull:

```
$ git branch
$ gbp pull
```

Building will create tarball and files in parent directory:

```
$ gbp buildpackage -S
$ ls ../icingaweb2*
../icingaweb2_2.7.3-2_amd64.build
../icingaweb2_2.7.3-2.debian.tar.xz
../icingaweb2_2.7.3-2.dsc
../icingaweb2_2.7.3.orig.tar.gz
```

> **Note:** When you want to build a specific version, you can just checkout the respective GIT tag or commit

Updating the changelog is very easy with gbp:

```
$ gbp dch -a
$ git diff debian/changelog
```

Building and changelog integration can also help with the release changelog, git commits and tags.

## Further reading

* [gbp manual](https://honk.sigxcpu.org/projects/git-buildpackage/manual-html/gbp.html)
* [`man gbp`](https://manpages.debian.org/unstable/git-buildpackage/gbp.1.en.html)
    * [`man gbp-buildpackage`](https://manpages.debian.org/unstable/git-buildpackage/gbp-buildpackage.1.en.html)
    * [`man gbp-dch`](https://manpages.debian.org/unstable/git-buildpackage/gbp-dch.1.en.html)
