# docker-deb-xxhash
Builder for the xxhash package on Debian:Jessie

It packs [https://github.com/Cyan4973/xxHash] into the `deb` packages (lib, cli, lib-dev) for the obsolete Debian.
The latest Debian already has it in oficial apt repo.

Run:
```bash
docker build -t xhash .

```