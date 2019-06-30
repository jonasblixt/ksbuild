
KS_PKG = jsonc
KS_PKG_VERSION =
KS_SDK_ARTEFACTS += build/output/$(KS_PKG)/sdk/:/sdk/

jsonc_build:
	@bash -c "mkdir -p /tmp/build \
    && curl -sL https://github.com/json-c/json-c/archive/json-c-0.13.1-20180305.tar.gz | tar xz -C /tmp/build \
    && cd /tmp/build/json-c-json-c-0.13.1-20180305 \
    && ./configure --host aarch64-linux-gnu --prefix /sdk \
            CFLAGS=-I/sdk/include \
            LDFLAGS=-L/sdk/lib \
            --enable-static \
    && make  \
    && make DESTDIR=/ksbuild/build/output/jsonc install \
    && rm -rf /tmp/build"

