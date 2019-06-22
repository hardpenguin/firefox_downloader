## Description

This script is meant to download the latest stable version of Firefox for Linux, then unpack it into the system-wide path.

It's especially useful in distributions such as Debian Stable that currently don't have a way to easily install and/or update Firefox.

## Status

Already implemented:

- basic functionality
- safeguards in case of problem with the target path or the archive

## Todo

- alternatives system support
- debug mode
- support for non-root users
- parameters support (e.g. language, temp path)