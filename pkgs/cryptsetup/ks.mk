
KS_PKG = cryptsetup
KS_PKG_VERSION =
KS_SDK_ARTEFACTS += build/output/$(KS_PKG)/sdk/:/sdk/

cryptsetup_build:
	@bash -c "mkdir -p /tmp/build \
    && curl -sL https://www.kernel.org/pub/linux/utils/cryptsetup/v2.1/cryptsetup-2.1.0.tar.xz | tar xJ -C /tmp/build \
    && cd /tmp/build/cryptsetup-2.1.0 \
    &&  ./configure --host aarch64-linux-gnu --prefix /sdk \
            CFLAGS=-I/sdk/include \
            LDFLAGS=-L/sdk/lib \
            --with-crypto_backend=kernel \
            --enable-static \
            --enable-static-libs \
    && make  \
    && make DESTDIR=/ksbuild/build/output/cryptsetup install \
    && rm -rf /tmp/build"

