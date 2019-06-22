
RUN mkdir -p /tmp/build \
    && curl -sL https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.34/util-linux-2.34.tar.gz | tar xz -C /tmp/build \
    && cd /tmp/build/util-linux-2.34 \
    && ./autogen.sh  \
	&& ./configure --host aarch64-linux-gnu --prefix /sdk \
	&& make  \
	&& make install \
    && rm -rf /tmp/build

RUN mkdir -p /tmp/build \
    && curl -sL https://launchpad.net/popt/head/1.16/+download/popt-1.16.tar.gz | tar xz -C /tmp/build \
    && cd tmp/build/popt-1.16 \
	&& ./autogen.sh  \
	&& ./configure CC=aarch64-linux-gnu-gcc --host arm-linux-gnu --prefix /sdk \
	&& make  \
	&& make install \
    && rm -rf /tmp/build/popt-1.16

RUN mkdir -p /tmp/build \
    && curl -sL https://pagure.io/libaio/archive/libaio-0.3.111/libaio-libaio-0.3.111.tar.gz | tar xz -C /tmp/build \
	&& cd tmp/build/libaio-libaio-0.3.111 \
	&& make  CC=aarch64-linux-gnu-gcc\
	&& make prefix=/sdk install \
    && rm -rf /tmp/build

RUN mkdir -p /tmp/build \
    && curl -sL ftp://sources.redhat.com/pub/lvm2/LVM2.2.03.05.tgz | tar xz -C /tmp/build \
    && cd /tmp/build/LVM2.2.03.05 \
    && ac_cv_func_realloc_0_nonnull=yes ac_cv_func_malloc_0_nonnull=yes \
                        ./configure --host aarch64-linux-gnu --prefix /sdk \
                        CFLAGS=-I/sdk/include \
                        LDFLAGS="-L/sdk/lib -L/usr/aarch64-linux-gnu/lib"\
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
    && make -C libdm/ install_static \
    && make -C libdm/ install_dynamic \
    && make -C libdm/ install_include \
    && rm -rf /tmp/build

RUN mkdir -p /tmp/build \
    && curl -sL https://github.com/json-c/json-c/archive/json-c-0.13.1-20180305.tar.gz | tar xz -C /tmp/build \
    && cd /tmp/build/json-c-json-c-0.13.1-20180305 \
    && ./configure --host aarch64-linux-gnu --prefix /sdk \
            CFLAGS=-I/sdk/include \
            LDFLAGS=-L/sdk/lib \
            --enable-static \
    && make  \
    && make install \
    && rm -rf /tmp/build

RUN mkdir -p /tmp/build \
    && curl -sL https://www.kernel.org/pub/linux/utils/cryptsetup/v2.1/cryptsetup-2.1.0.tar.xz | tar xJ -C /tmp/build \
    && cd /tmp/build/cryptsetup-2.1.0 \
    &&  ./configure --host aarch64-linux-gnu --prefix /sdk \
            CFLAGS=-I/sdk/include \
            LDFLAGS=-L/sdk/lib \
            --with-crypto_backend=kernel \
            --enable-static \
            --enable-static-libs \
    && make  \
    && make install \
    && rm -rf /tmp/build
 
RUN mkdir -p /tmp/build \
    && cd /tmp/build \
    && mkdir -p /sdk/initrd/ \
    && git clone https://github.com/jonpe960/kickstart /tmp/build/kickstart \
    && export CROSS_COMPILE=aarch64-linux-gnu- \
    && make -C /tmp/build/kickstart/src \
    && cp /tmp/build/kickstart/src/build/kickstart /sdk/initrd/init \
    && rm -rf /tmp/build

COPY initrd/create_initrd /
