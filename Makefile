CMAKE_INSTALL_PREFIX ?= $(HOME)/.cmake_install
BENCHMARK_BINARY_DIR := $(abspath dist/benchmark)
BENCHMARK_SOURCE_DIR := $(abspath benchmark)
GOOGLETEST_BINARY_DIR := $(abspath dist/googletest)
GOOGLETEST_SOURCE_DIR := $(abspath googletest)

.PHONY: all reset_submodules clean \
	clean_benchmark \
	build_benchmark \
	install_benchmark \
	clean_googletest \
	build_googletest \
	install_googletest \

all:
	@echo nothing special

reset_submodules:
	git submodule update --init --recursive

clean:
	rm -rf build dist

build: build_benchmark build_googletest

install: install_benchmark install_googletest

clean_googletest:
	rm -rf $(GOOGLETEST_BINARY_DIR)
install_googletest: build_googletest
	cd $(GOOGLETEST_BINARY_DIR) && \
		make install
build_googletest: 
	mkdir -p $(GOOGLETEST_BINARY_DIR) && cd $(GOOGLETEST_BINARY_DIR) && \
		cmake $(GOOGLETEST_SOURCE_DIR) \
			-DCMAKE_INSTALL_PREFIX=$(CMAKE_INSTALL_PREFIX) \
			-DCMAKE_BUILD_TYPE=Release && \
		make -j4

clean_benchmark:
	rm -rf $(BENCHMARK_BINARY_DIR)
install_benchmark: build_benchmark
	rm $(BENCHMARK_SOURCE_DIR)/googletest -f && \
		ln -s $(GOOGLETEST_SOURCE_DIR) $(BENCHMARK_SOURCE_DIR)/googletest
	cd $(BENCHMARK_BINARY_DIR) && \
		make install
	rm $(BENCHMARK_SOURCE_DIR)/googletest
build_benchmark: 
	rm $(BENCHMARK_SOURCE_DIR)/googletest -f && \
		ln -s $(GOOGLETEST_SOURCE_DIR) $(BENCHMARK_SOURCE_DIR)/googletest
	mkdir -p $(BENCHMARK_BINARY_DIR) && cd $(BENCHMARK_BINARY_DIR) && \
		cmake $(BENCHMARK_SOURCE_DIR) \
			-DCMAKE_INSTALL_PREFIX=$(CMAKE_INSTALL_PREFIX) && \
		make -j4
	rm $(BENCHMARK_SOURCE_DIR)/googletest
