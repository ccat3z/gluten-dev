# Build Options
override VELOX_REPO_DEFAULT:=ep/build-velox/build/velox_ep
VELOX_REPO  = $(VELOX_REPO_DEFAULT)
BUILD_TYPE  = Release
SKIP_MAVEN  = y
JAR_PACKAGE = package/target/gluten-velox-bundle-spark3.3_2.12-centos_7-0.5.0-SNAPSHOT.jar

# Alias
.PHONY: all clean
all: $(JAR_PACKAGE)
clean: clean-gluten-velox clean-velox clean-arrow
	-rm $(JAR_PACKAGE)

# Gluten Velox Backend (Jar Package)
ifeq ("","$(wildcard $(JAR_PACKAGE))")
SKIP_MAVEN=n
endif

ifeq (y,$(SKIP_MAVEN))
.PHONY: $(JAR_PACKAGE)
$(JAR_PACKAGE): build-gluten-velox
	cd cpp/build/releases && jar -uf "$(JAR_PACKAGE)" libvelox.so libgluten.so
else
$(JAR_PACKAGE): build-gluten-velox
	mvn clean package -Pbackends-velox -Prss -Pspark-3.3 -DskipTests
	test -f $@
endif

# Gluten Velox Backend (Shared Library)
.PHONY: build-gluten-velox clean-gluten-velox
cpp/build:
	cmake \
		"-B$@" \
		-DBUILD_VELOX_BACKEND=ON \
		-DCMAKE_BUILD_TYPE=$(BUILD_TYPE) \
      	-DBUILD_TESTS=ON \
		-DBUILD_BENCHMARKS=ON \
		-DBUILD_JEMALLOC=ON \
      	-DENABLE_HBM=OFF \
		-DENABLE_QAT=OFF \
		-DENABLE_IAA=OFF \
		-DENABLE_S3=ON \
		-DENABLE_HDFS=ON \
		cpp
build-gluten-velox: build-velox | cpp/build
	$(DOCKER_BUILDER_SHELL) cmake --build "cpp/build" -j
clean-gluten-velox:
	-rm -rf cpp/build

# Velox EP
.PHONY: $(VELOX_REPO_DEFAULT) build-velox clean-velox
$(VELOX_REPO_DEFAULT):
	./ep/build-velox/src/get_velox.sh
build-velox: $(VELOX_REPO) build-arrow
	./ep/build-velox/src/build_velox.sh \
		--velox_home="$(abspath $(VELOX_REPO))" \
		--enable_s3=ON \
		--enable_hdfs=ON \
		--build_benchmarks=ON \
		--build_type="$(BUILD_TYPE)" \
		--enable_ep_cache=ON
clean-velox: $(VELOX_REPO)
	-rm -rf $(VELOX_REPO)/_build

# Arrow EP
.PHONY: build-arrow clean-arrow
build-arrow:
	./ep/build-arrow/src/get_arrow.sh \
		--enable_custom_codec=ON
	./ep/build-arrow/src/build_arrow.sh \
		--build_type=Release \
		--build_tests=ON \
		--build_benchmarks=ON \
		--enable_ep_cache=ON
clean-arrow:
	-rm -rf ep/build-arrow/build