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
install: ## Install package
	sudo pacman -S --needed - < pkg/pacman.txt
	pip install --user -r pkg/pip.txt

.PHONY: deploy
deploy: ## Create links
	mkdir -p $(HOME)/.config
	stow -v -R -t $(HOME) userhome
	#stow -v -t $(HOME) userhome

.PHONY: withdraw
withdraw: ## Remove links
	stow -v -t $(HOME) -D userhome

.PHONY: pkglist
pkglist: | pkg pkg/pacman.txt pkg/pip.txt ## Update package list

pkg/pacman.txt:
	pacman -Qqe > $@

pkg/pip.txt:
	pip freeze --user > $@
