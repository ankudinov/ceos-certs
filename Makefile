CURRENT_DIR := $(shell pwd)

.PHONY: help
help: ## Display help message
	@grep -E '^[0-9a-zA-Z_-]+\.*[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: start
start: ## Deploy ceos lab
	sudo containerlab deploy --debug --topo $(CURRENT_DIR)/cert-lab.clab.yml --max-workers 2 --timeout 5m --reconfigure

.PHONY: stop
stop: ## Destroy ceos lab
	sudo containerlab destroy --debug --topo $(CURRENT_DIR)/cert-lab.clab.yml --cleanup

.PHONY: cmdo
cmdo: ## collect snapshot with cmdo
	cmdo -i cmdo_inventory.yml -o .gitignored/
