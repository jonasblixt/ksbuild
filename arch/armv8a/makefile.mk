

arch_step:
	@echo "# --- ARCH BEGIN ---" >> build/Dockerfile
	@cat arch/armv8a/arch.Dockerfile >> build/Dockerfile
	@echo "# --- ARCH END ---" >> build/Dockerfile
