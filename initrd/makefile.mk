
INITRD_PKGS = 

include initrd/util-linux.mk
include initrd/popt.mk
include initrd/libaio.mk
include initrd/lvm2.mk
include initrd/jsonc.mk
include initrd/cryptosetup.mk

initrd_preflight:
	@mkdir -p $(KS_SDK)/initrd/proc
	@mkdir -p $(KS_SDK)/initrd/dev
	@mkdir -p $(KS_SDK)/initrd/lib
	@mkdir -p $(KS_SDK)/initrd/sys
	@mkdir -p /tmp/build

initrd_packages: initrd_preflight $(INITRD_PKGS)


initrd_step:
	@echo Building initrd
	@$(DOCKER) run -v $(shell readlink -f .):/work ks-builder:latest \
		make -C /work PLAT=$(PLAT) initrd_packages

initrd_cpio:
	@PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) make -C kickstart/ CROSS_COMPILE=aarch64-linux-gnu- clean
	@PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) make -C kickstart/ CROSS_COMPILE=aarch64-linux-gnu-
	@mkdir -p $(BUILD_DIR)/initrd/newroot
	@cp kickstart/build/kickstart $(BUILD_DIR)/initrd/init
	@cd $(BUILD_DIR)/initrd && \
		 find . | cpio -H newc -o > ../initramfs.cpio
