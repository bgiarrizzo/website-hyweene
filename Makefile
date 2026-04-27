.DEFAULT_GOAL := help

PROJECT_BINARY_NAME := HyweeneSiteGeneratorBin
PROJECT_FOLDER := $(shell pwd)
BIN_FOLDER := bin
BUILD_FOLDER := build
GENERATOR_FOLDER := generator
SCRIPTS_FOLDER := scripts
SITE_CONTENT_FOLDER := site-content
DOTENV_FILE := .env

DOTENV_PATH := $(PROJECT_FOLDER)/$(DOTENV_FILE)
SCRIPTS_PATH := $(PROJECT_FOLDER)/$(SCRIPTS_FOLDER)
GENERATOR_PATH := $(PROJECT_FOLDER)/$(GENERATOR_FOLDER)

# Check if .env file exists and load it
ifneq ("$(wildcard $(DOTENV_PATH))","")
	include $(DOTENV_FILE)
	export
endif

.PHONY: help
help:
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##)|(^##)' $(firstword $(MAKEFILE_LIST)) | awk 'BEGIN {FS = ":.*?## "; printf "Usage: make \033[32m<target>\033[0m\n"}{printf "\033[32m%-20s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m## /\n[33m/'

.PHONY: install
install: ## Install Swift dependencies (via Swift Package Manager)
	@echo "Installing Swift dependencies..."
	cd $(GENERATOR_FOLDER) && swift package resolve
	@echo "✓ Dependencies installed"

.PHONY: install_smolwebvalidator
install_smolwebvalidator: ## Install smolweb-validator
	mkdir -p $(BIN_FOLDER)
	@if [ ! -d "$(BIN_FOLDER)/smolweb-validator" ]; then \
		git clone https://codeberg.org/smolweb/smolweb-validator.git $(BIN_FOLDER)/smolweb-validator; \
		cd $(BIN_FOLDER)/smolweb-validator; bash build.sh; \
	else \
		echo "smolweb-validator is already installed in $(BIN_FOLDER)/smolweb-validator"; \
		exit 0; \
	fi

.PHONY: build
build: install ## Build the static site with Swift generator
	@echo "Building Swift generator..."
	cd $(GENERATOR_FOLDER) && swift build -c release
	@echo "Generating site..."
	$(GENERATOR_FOLDER)/.build/release/$(PROJECT_BINARY_NAME)
	@echo "✓ Site built successfully in build/"

.PHONY: build-debug
build-debug: install ## Build in debug mode (faster compilation, slower execution)
	@echo "Building Swift generator (debug)..."
	cd $(GENERATOR_FOLDER) && swift build
	@echo "Generating site..."
	$(GENERATOR_FOLDER)/.build/debug/$(PROJECT_BINARY_NAME)
	@echo "✓ Site built successfully in build/"

.PHONY: build-linux
build-linux: ## Build and test on Linux (requires Docker/Podman)
	@echo "Testing cross-platform support on Linux..."
	@command -v podman >/dev/null 2>&1 && CONTAINER_ENGINE=podman || CONTAINER_ENGINE=docker; \
	$$CONTAINER_ENGINE run --rm \
		-v "$(PROJECT_FOLDER)/$(GENERATOR_FOLDER):/workspace/$(GENERATOR_FOLDER):ro" \
		-v "$(PROJECT_FOLDER)/$(SITE_CONTENT_FOLDER):/workspace/$(SITE_CONTENT_FOLDER):ro" \
		-v "$(PROJECT_FOLDER)/releases:/workspace/releases" \
		-w /workspace \
		swift:5.10 \
		bash -c "cd $(GENERATOR_FOLDER) && swift build -c release && cd .. && ./$(GENERATOR_FOLDER)/.build/release/$(PROJECT_NAME)"
	@echo "✓ Linux build completed successfully"

.PHONY: test
test: ## Run unit tests
	@echo "Running unit tests..."
	cd $(GENERATOR_FOLDER) && swift test

.PHONY: test-verbose
test-verbose: ## Run tests with verbose output
	@echo "Running tests (verbose)..."
	cd $(GENERATOR_FOLDER) && swift test --verbose

.PHONY: serve
serve: build ## Run a local HTTP server (use swift serve for a more robust option)
	@echo "Starting local server on http://localhost:8000"


.PHONY: stop-serve
stop-serve: ## Stop the local HTTP server
	@ps -ef | grep '[p]ython.*http.server.*8000' | awk '{print $$2}' | xargs -r kill -9 2>/dev/null || true
	@echo "✓ Server stopped"

.PHONY: smolwebvalidator
smolwebvalidator: install_smolwebvalidator serve ## Validate HTML files with smolweb-validator
	@echo "Running SmolWeb validation..."
	bash $(SCRIPTS_PATH)/smolweb_validator.sh
	@echo "Stopping local server..."
	@$(MAKE) stop-serve

.PHONY: html5validator
html5validator: build ## Validate HTML5 compliance (requires html5validator)
	@command -v html5validator >/dev/null 2>&1 || { echo "html5validator not found. Install with: pip install html5validator"; exit 1; }
	html5validator --root build/

.PHONY: quick_add_link
quick_add_link: ## Quick add a new link (requires Python script)
	@command -v python3 >/dev/null 2>&1 || { echo "Python3 not found"; exit 1; }
	python3 $(SCRIPTS_PATH)/quick_add_link.py $(URL)
