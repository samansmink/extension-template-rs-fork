.PHONY: clean clean_all

PROJ_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# TODO: these values are currently duplicated in lib.rs. There's a PR open in duckdb-rs that fixes this
EXTENSION_NAME=rusty_quack
MINIMUM_DUCKDB_VERSION=v0.0.1

all: configure debug

# Include makefiles from DuckDB
include extension-ci-tools/makefiles/duckdb_extension_c_api.Makefile
include extension-ci-tools/makefiles/duckdb_extension_rs.Makefile

configure: venv platform extension_version

debug: build_extension_library_debug build_extension_with_metadata_debug
release: build_extension_library_release build_extension_with_metadata_release

test: test_debug
test_debug: test_extension_debug
test_release: test_extension_release

clean: clean_build clean_rust
clean_all: clean_configure clean

wasm_mvp: export DUCKDB_PLATFORM = wasm_mvp
wasm_mvp: configure release
	cp -r build/release build/wasm_mvp

wasm_eh: export DUCKDB_PLATFORM = wasm_eh
wasm_eh: configure release
	cp -r build/release build/wasm_eh

wasm_threads: export DUCKDB_PLATFORM = wasm_coi
wasm_threads: configure release
	cp -r build/release build/wasm_threads
