
DOCKER ?= $(shell which docker)

BUILD_TARGETS =

all:
	@$(DOCKER) run -it --rm -u $(shell id -u $$USER) \
	   			-v $(shell readlink -f $(PKG)):/pkg \
	   			-v $(shell readlink -f .):/ksbuild \
			  	ks-builder:latest \
			    make -C /ksbuild pkg DOCKER_PKG=/pkg
ifdef DOCKER_PKG
-include /pkg/ks.mk
$(info Building package ${KS_PKG}:${KS_PKG_VERSION})
BUILD_TARGETS += $(KS_PKG)_build
endif

pkg: $(BUILD_TARGETS)
	@echo Build completed


