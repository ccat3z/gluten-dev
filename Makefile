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
hadoop1:
	docker compose exec -u hdfs hadoop1 bash

#
# Gluten Builder
#

GLUTEN_REPO = $(error "GLUTEN_REPO is required")
override GLUTEN_REPO := $(abspath $(GLUTEN_REPO))
VELOX_REPO  =

# Host Cache Dirs
CCACHE_DIR=$(HOME)/.ccache
VCPKG_BINARY_CACHE_DIR=$(HOME)/.cache/vcpkg
MAVEN_M2_DIR=$(HOME)/.m2

# Docker Builder
DOCKER_BUILDER_IMAGE     = gluten-builder-vcpkg
DOCKER_MOUNT_DIRS        = $(GLUTEN_REPO) $(VCPKG_BINARY_CACHE_DIR) $(MAVEN_M2_DIR) $(CCACHE_DIR)
DOCKER_BUILDER_RUN_FLAGS = \
	-v $(GLUTEN_REPO):$(GLUTEN_REPO) \
	-v $(VCPKG_BINARY_CACHE_DIR):/home/build/.cache/vcpkg \
	-v $(MAVEN_M2_DIR):/home/build/.m2 \
	-v $(CCACHE_DIR):/home/build/.ccache \
	-v $(CURDIR)/docker/builder/Makefile:$(GLUTEN_REPO)/Makefile:ro \
	--workdir $(GLUTEN_REPO)
DOCKER_BUILDER_SHELL = docker run --rm -ti $(DOCKER_BUILDER_RUN_FLAGS) $(DOCKER_BUILDER_IMAGE)

ifneq ("$(VELOX_REPO)","")
override VELOX_REPO := $(abspath $(VELOX_REPO))
DOCKER_MOUNT_DIRS += $(VELOX_REPO)
DOCKER_BUILDER_RUN_FLAGS += -v $(VELOX_REPO):$(VELOX_REPO)
endif

.PHONY: builder builder-image
builder: builder-image $(DOCKER_MOUNT_DIRS)
	$(DOCKER_BUILDER_SHELL) bash 
builder-image:
	cd $(GLUTEN_REPO)/dev/vcpkg && docker build \
		--file docker/Dockerfile \
		--build-arg BUILDER_UID=`id -u` \
		--build-arg BUILDER_GID=`id -g` \
		--tag "$(DOCKER_BUILDER_IMAGE)" \
		.

$(CCACHE_DIR) $(VCPKG_BINARY_CACHE_DIR) $(MAVEN_M2_DIR): %:
	mkdir -p $@