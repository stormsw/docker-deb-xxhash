FROM debian:jessie as base
# Build the dep package of 
# https://github.com/Cyan4973/xxHash/tree/v0.7.3

ENV DEBIAN_FRONTEND noninteractive

#RUN echo "deb-src http://deb.debian.org/debian jessie main">>/etc/apt/sources.list
# We need at least one source repo in order to build packages
RUN apt-get update && apt-get install -y --no-install-recommends software-properties-common \
            unzip \
            build-essential autoconf automake autotools-dev dh-make debhelper devscripts fakeroot xutils lintian pbuilder \
            cmake\
            clang \
            g++-multilib \
            gcc-multilib \
            cppcheck && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ENV DEBIAN_FRONTEND newt

WORKDIR /package
COPY debian/ ./src/debian
ADD https://github.com/Cyan4973/xxHash/archive/master.zip .
RUN temp=$(mktemp -d) \
    && unzip -d "$temp" master.zip \
    && mkdir -p ./src \
    && mv "$temp"/*/* ./src \
    && cd src/cmake_unofficial \
    && mkdir build && cd build \
    && cmake .. \
    && make install \
    && cd /package/src \
    && dpkg-buildpackage -rfakeroot \
    && rm -rf "$temp" && rm ../*.zip

FROM debian:jessie as final
WORKDIR /app
COPY --from=base /package/*.deb ./
RUN dpkg -i *.deb
CMD ["-b1"]
# Use like: xxhsum --strict --status -H2 /dev/shm
ENTRYPOINT [ "xxhsum", "--strict", "--status", "-H2" ]