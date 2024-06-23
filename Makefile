.PHONY: all
all:

#
# Hadoop Cluster 
#

.PHONY: redeploy hadoop1
.env: .env.gen
	./.env.gen > $@
redeploy: .env
	docker compose down -v
	docker compose up -d --build

#
# Editor
#

.PHONY: gen-clangd 
gen-clangd: $(GLUTEN_REPO)/cpp/.clangd $(VELOX_REPO)/.clangd
$(GLUTEN_REPO)/cpp/.clangd: Makefile .clangd.gen
	CMAKE_BUILD_DIR=build ./.clangd.gen > $@
$(VELOX_REPO)/.clangd: Makefile .clangd.gen
	CMAKE_BUILD_DIR=_build/debug ./.clangd.gen > $@
