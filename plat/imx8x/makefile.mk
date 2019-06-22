
ARCH = armv8a

plat_step:
	@echo "# --- PLAT BEGIN ---" >> build/Dockerfile
	@cat plat/imx8x/plat.Dockerfile >> build/Dockerfile
	@echo "# --- PLAT END ---" >> build/Dockerfile
