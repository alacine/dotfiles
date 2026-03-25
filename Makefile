SHELL := /bin/bash

##@ General

# The help target prints out all targets with their descriptions organized
# beneath their categories. The categories are represented by '##@' and the
# target descriptions by '##'. The awk commands is responsible for reading the
# entire set of makefiles included in this invocation, looking for lines of the
# file as xyz: ## something, and then pretty-format the target and help. Then,
# if there's a line with ##@ something, that gets pretty-printed as a category.
# More info on the usage of ANSI control characters for terminal formatting:
# https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_parameters
# More info on the awk command:
# http://linuxcommand.org/lc3_adv_awk.php

.PHONY: help
help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} \
		/^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } \
		/^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' \
		$(MAKEFILE_LIST)

.PHONY: install
install: install-gui ## Install full GUI environment (default)

.PHONY: install-gui
install-gui: ## Install GUI desktop environment (includes CLI)
	cd pkg && makepkg -sif --needed --noconfirm -p PKGBUILD-cli
	# rustup default stable
	cd pkg && makepkg -sif --needed --noconfirm -p PKGBUILD-gui
	grep -v '^\s*#\|^\s*$$' pkg/aur-cli.txt | xargs paru -S --needed --noconfirm
	grep -v '^\s*#\|^\s*$$' pkg/aur-gui.txt | xargs paru -S --needed --noconfirm

.PHONY: install-cli
install-cli: ## Install CLI/dev environment only (for VMs)
	cd pkg && makepkg -sif --needed --noconfirm -p PKGBUILD-cli
	rustup default stable
	grep -v '^\s*#\|^\s*$$' pkg/aur-cli.txt | xargs paru -S --needed --noconfirm
	chsh -s /usr/bin/zsh $(USER)

.PHONY: deploy
deploy: ## Create links
	mkdir -p $(HOME)/{.config,.local/share,.claude,.vagrant.d}
	stow -v -R -t $(HOME) userhome
	fc-cache -f

.PHONY: withdraw
withdraw: ## Remove links
	stow -v -t $(HOME) -D userhome

.PHONY: setup-mirror
setup-mirror: ## (Root) Setup mirror for archlinuxcn
	sudo ./mirrors.sh
