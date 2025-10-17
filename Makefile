# file: Makefile
UV ?= uv
PY := $(UV) run -q python
PANDOC ?= pandoc

BUILD_DIR := build
TMP_DIR := $(BUILD_DIR)/tmp
MAP_DIR := $(BUILD_DIR)/maps
REPORT_DIR := $(BUILD_DIR)/reports

SRC_MDK := upstream/P4-16-spec.mdk
ATX_MD  := $(TMP_DIR)/P4-16-spec.atx.md
OUTLINE := $(MAP_DIR)/mdk_outline.json
DOCS    := docs

.PHONY: all prep normalize outline split figs verify clean

all: prep normalize outline split figs verify

prep:
	@mkdir -p $(TMP_DIR) $(MAP_DIR) $(REPORT_DIR) $(DOCS)/assets/figs

normalize: $(SRC_MDK)
	@$(PY) scripts/normalize_mdk.py --in $(SRC_MDK) --out $(ATX_MD)

outline: normalize
	@$(PY) scripts/outline_mdk.py --in $(ATX_MD) --out $(OUTLINE) --version v1.2.5

split: outline
	@$(PY) scripts/split_mdk.py --in $(ATX_MD) --map $(OUTLINE) --docs $(DOCS)

figs:
	@$(PY) scripts/sync_figs.py --src upstream/figs --dst $(DOCS)/assets/figs

verify:
	@$(PY) scripts/verify_site.py --docs $(DOCS) --map $(OUTLINE) --report $(REPORT_DIR)/verify.json

clean:
	@rm -rf $(BUILD_DIR)
