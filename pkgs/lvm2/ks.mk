
KS_PKG = lvm2
KS_PKG_VERSION =
KS_SDK_ARTEFACTS += build/output/$(KS_PKG)/sdk/:/sdk/

lvm2_build:
	@bash -c "mkdir -p /tmp/build \
    && curl -sL ftp://sources.redhat.com/pub/lvm2/LVM2.2.03.05.tgz | tar xz -C /tmp/build \
    && cd /tmp/build/LVM2.2.03.05 \
    && ac_cv_func_realloc_0_nonnull=yes ac_cv_func_malloc_0_nonnull=yes \
                        ./configure --host aarch64-linux-gnu --prefix /sdk \
                        CFLAGS=-I/sdk/include \
                        LDFLAGS=\"-L/sdk/lib -L/usr/aarch64-linux-gnu/lib\" \
                        --disable-nls \
                        --disable-cmdlib \
                        --disable-makeinstall-chown \
                        --disable-dmeventd \
                        --disable-fsadm \
                        --disable-dbus-service \
                        --disable-devmapper \
                        --disable-readline \
                        --disable-selinux \
                        --disable-dmsetup \
                        --enable-static_link \
    && make -C libdm/ libdevmapper.so \
    && make -C libdm/ DESTDIR=/ksbuild/build/output/lvm2/ install_static \
    && make -C libdm/ DESTDIR=/ksbuild/build/output/lvm2/ install_dynamic \
    && make -C libdm/ DESTDIR=/ksbuild/build/output/lvm2/ install_include \
    && rm -rf /tmp/build"

