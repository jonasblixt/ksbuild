
KS_PKG = popt
KS_PKG_VERSION =
KS_SDK_ARTEFACTS += build/output/$(KS_PKG)/sdk/:/sdk/

popt_build:
	@bash -c "mkdir -p /tmp/build \
    && curl -sL https://launchpad.net/popt/head/1.16/+download/popt-1.16.tar.gz | tar xz -C /tmp/build \
    && cd /tmp/build/popt-1.16 \
        && ./autogen.sh  \
        && ./configure CC=aarch64-linux-gnu-gcc \
			--host arm-linux-gnu \
			--prefix /sdk \
        && make -j8 \
        && make install DESTDIR=/ksbuild/build/output/popt install \
    && rm -rf /tmp/build/popt-1.16"

