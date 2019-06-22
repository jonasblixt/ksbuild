
INITRD_PKGS += pkg_lvm2

pkg_lvm2:
	@tar xf /work/dl/LVM2.2.03.05.tgz -C $(BUILD_DIR)/build/
	@cd $(BUILD_DIR)/build/LVM2.2.03.05 && \
	ac_cv_func_realloc_0_nonnull=yes ac_cv_func_malloc_0_nonnull=yes \
			./configure --host aarch64-linux-gnu --prefix $(BUILD_DIR)/target \
			CFLAGS=-I/work/src/build/target/include \
			LDFLAGS="-L/work/src/build/target/lib -L/usr/aarch64-linux-gnu/lib"\
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
		&& make -C libdm/ install_include
