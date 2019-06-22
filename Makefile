
DOCKER ?= $(shell which docker)

ifndef PLAT
$(error PLAT is not set)
endif

MAKE_HELPERS = $(wildcard make/*.mk)
USER_UID = $(shell id -u $$USER)

include $(MAKE_HELPERS)
include plat/$(PLAT)/makefile.mk
include arch/$(ARCH)/makefile.mk

$(shell mkdir -p build)
$(shell echo > build/Dockerfile)
.PHONY: initrd_step initrd

base_step:
	@cat base.Dockerfile > build/Dockerfile

all: base_step arch_step plat_step
	@echo "# --- INITRD BEGIN ---" >> build/Dockerfile
	@cat initrd/initrd.Dockerfile >> build/Dockerfile
	@echo "# --- INITRD END ---" >> build/Dockerfile
	@$(DOCKER) build -t ks-builder:latest -f build/Dockerfile .

initrd:
	@$(DOCKER) run --rm -u $(shell id -u $$USER):$(shell id -g) \
	   			   -e KS_ROOT_HASH='$(ROOT_HASH)' \
				   -v $(shell readlink -f .)/build/:/output/ ks-builder:latest \
				   /create_initrd
	@echo build/initrd.cpio ready
.DEFAULT_GOAL := all

