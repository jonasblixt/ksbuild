
ENV KS_ARCH=armv8a
ENV PKG_CONFIG_PATH="/sdk/lib/pkgconfig"
ENV KS_SYSROOT="/sdk"

RUN    cp -aR /usr/aarch64-linux-gnu/lib /sdk/ \
       && cp -aR /usr/aarch64-linux-gnu/lib /sdk/

CMD ["bash","--rcfile", "/bashrc"]
