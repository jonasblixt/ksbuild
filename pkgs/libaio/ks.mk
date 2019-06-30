
KS_PKG = libaio
KS_PKG_VERSION =
KS_SDK_ARTEFACTS += build/output/$(KS_PKG)/sdk/:/sdk/

libaio_build:
	@bash -c "mkdir -p /tmp/build \
	&& mkdir -p /ksbuild/build/output/libaio/sdk/ \
    && curl -sL https://pagure.io/libaio/archive/libaio-0.3.111/libaio-libaio-0.3.111.tar.gz | tar xz -C /tmp/build \
        && cd /tmp/build/libaio-libaio-0.3.111 \
        && make  CC=aarch64-linux-gnu-gcc\
        && make prefix=/ksbuild/build/output/libaio/sdk/ install \
    && rm -rf /tmp/build"

