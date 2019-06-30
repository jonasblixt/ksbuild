
KS_PKG = util_linux
KS_PKG_VERSION = 
KS_SDK_ARTEFACTS += build/output/util_linux/sdk/:/sdk/

util_linux_build:
	@echo util_linux build
	@bash -c "mkdir -p /tmp/build \
	&& mkdir -p /tmp/build/output \
    && curl -sL https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.34/util-linux-2.34.tar.gz | tar xz -C /tmp/build \
    && cd /tmp/build/util-linux-2.34 \
    && patch -p 1 < /pkg/0001-libblkid.patch \
    && ./autogen.sh  \
	&& ./configure --host aarch64-linux-gnu \
		--prefix /sdk \
		--disable-makeinstall-chown \
		--disable-makeinstall-setuid \
	&& make -j8 \
	&& make DESTDIR=/ksbuild/build/output/util_linux install \
    && rm -rf /tmp/build"

