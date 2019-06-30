
DOCKER ?= $(shell which docker)
SDK ?= ks-builder:latest

BUILD_TARGETS =
KS_SDK_ARTEFACTS =
DOCKERFILE =

all:
	@echo Help:
	@echo -- Implement me --


ifdef PKG
-include $(PKG)/ks.mk
endif

ifdef DOCKER_PKG
-include /pkg/ks.mk
endif

KS_BUILD_HOOKS =

-include /ksbuild/build/*.mk

BUILD_TARGETS += $(KS_PKG)_build
BUILD_CLEAN_TARGETS += $(KS_PKG)_clean

build/.ks_prepare:
	@mkdir -p $(dir $@)
	@cat base.Dockerfile > build/Dockerfile

	$(foreach ks, $(shell find build/ -name "ks.Dockerfile"), \
		cat $(ks) >> build/Dockerfile; )
	@touch $@

build/output/$(KS_PKG)/.pkg_build:
	@mkdir -p $(dir $@)
	@$(DOCKER) run --rm -u $(shell id -u $$USER) \
	   			-v $(shell readlink -f $(PKG)):/pkg \
	   			-v $(shell readlink -f .):/ksbuild \
			  	$(SDK) \
			    make -C /ksbuild ksbuild_pkg DOCKER_PKG=$(PKG)
	@touch $@

build/output/$(KS_PKG)/.sdk_pop: build/.ks_prepare
	@mkdir -p $(dir $@)
	@echo > build/output/$(KS_PKG)/ks.Dockerfile
	@$(foreach a, $(KS_SDK_ARTEFACTS), \
		echo COPY $(subst :, ,$a) >> build/output/$(KS_PKG)/ks.Dockerfile;)

	@cat base.Dockerfile > build/Dockerfile
	@cat build/output/$(KS_PKG)/ks.Dockerfile >> build/Dockerfile
	$(foreach ks, $(shell find build/ -name "ks.Dockerfile"), \
		cat $(ks) >> build/Dockerfile; )

	@$(DOCKER) build -t ks-builder:latest -f build/Dockerfile .
	@touch $@

pkg: build/output/$(KS_PKG)/.pkg_build \
	 build/output/$(KS_PKG)/.sdk_pop
	@echo $(PKG) build completed

ks_pkg_clean_build:
	@rm -rf build/output/$(KS_PKG)/

	@$(DOCKER) run --rm -u $(shell id -u $$USER) \
	   			-v $(shell readlink -f $(PKG)):/pkg \
	   			-v $(shell readlink -f .):/ksbuild \
			  	$(SDK) \
			    make -C /ksbuild ksbuild_pkg_clean DOCKER_PKG=$(PKG)

pkg-rebuild: ks_pkg_clean_build pkg

bootstrap:
	@cat base.Dockerfile > build/Dockerfile
	@$(DOCKER) build -t ks-builder:latest -f build/Dockerfile .

shell:
	@echo Starting dev-shell
	@$(DOCKER) run -it --rm -u $(shell id -u $$USER) \
	   			-v $(shell readlink -f $(WORKDIR)):/work \
	   			-v $(shell readlink -f .):/ksbuild \
			  	$(SDK)

app: $(KS_APP)_deps
	@mkdir -p $(PKG)/build
	@$(DOCKER) run --rm -u $(shell id -u $$USER) \
	   			-v $(shell readlink -f $(PKG)):/pkg \
	   			-v $(shell readlink -f .):/ksbuild \
			  	$(SDK) \
			    make -C /ksbuild ksbuild_app DOCKER_PKG=$(PKG)

ksbuild_app: $(KS_BUILD_HOOKS)
	@echo Building $(DOCKER_PKG) completed

ksbuild_pkg: $(BUILD_TARGETS)

.PHONY: $(BUILD_CLEAN_TARGETS)

ksbuild_pkg_clean: $(BUILD_CLEAN_TARGETS)
