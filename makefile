# Makefile for DebianDuke

# Determine Version from conventional commits messages since last version
LAST_VERSION = $(shell cat version.txt)
COMMITS = $(shell git log --oneline $(LAST_VERSION)..HEAD)
VERSION_BUMP_TYPE = $(shell echo $(COMMITS) | grep -q "!" && echo "major" || (echo $(COMMITS) | grep -q "feat" && echo "minor" || echo "patch"))

ifeq ($(VERSION_BUMP_TYPE), major)
	NEW_VERSION = $(shell echo $(LAST_VERSION) | awk -F. -v OFS=. '{print $$1 + 1, 0, 0}')
endif
ifeq ($(VERSION_BUMP_TYPE), minor)
	NEW_VERSION = $(shell echo $(LAST_VERSION) | awk -F. -v OFS=. '{print $$1, $$2 + 1, 0}')
endif
ifeq ($(VERSION_BUMP_TYPE), patch)
	NEW_VERSION = $(shell echo $(LAST_VERSION) | awk -F. -v OFS=. '{print $$1, $$2, $$3 + 1}')
endif

debug:
	@echo "Last Version: $(LAST_VERSION)"
	@echo "Commits: $(COMMITS)"
	@echo "Version Bump Type: $(VERSION_BUMP_TYPE)"
	@echo "New Version: $(NEW_VERSION)"

set-version:
	git tag $(NEW_VERSION)
	echo $(NEW_VERSION) > version.txt

release: set-version
	@read -p "Are you sure you want to push the new version? (y/n) " answer; \
	if [ "$$answer" != "y" ]; then \
		echo "Push cancelled."; \
	else \
		git push origin $(NEW_VERSION); \
	fi

# Build the Duke Builder Container
build-duke-builder:
	docker build -t duke-builder -f duke-builder.dockerfile .

# Run the Duke Builder Container
run-duke-builder: build-duke-builder
	docker run --name duke-builder --privileged -d duke-builder

# Copy the Duke Config into the Duke Builder Container
copy-config: run-duke-builder
	docker cp ./duke duke-builder:/

# Build the Duke ISO
build-iso: copy-config
	docker exec -t duke-builder /bin/bash -c "cd /duke && lb clean && lb config && lb build"

# Copy the Duke ISO out of the Duke Builder Container & Copy build logs & generated config files
move: build-iso
	docker cp duke-builder:/duke/live-image-amd64.hybrid.iso ./dist/duke.hybrid.iso
	docker cp duke-builder:/duke/build.log ./dist/build.log
	docker cp duke-builder:/duke/config/bootstrap ./duke/config/bootstrap
	docker cp duke-builder:/duke/config/chroot ./duke/config/chroot
	docker cp duke-builder:/duke/config/common ./duke/config/common
	docker cp duke-builder:/duke/config/binary ./duke/config/binary
	docker cp duke-builder:/duke/config/source ./duke/config/source

# Clean up the Duke Builder Container and Image if they exist
stop-and-remove-container:
	if [ ! -z $$(docker ps -a -q --filter "name=duke-builder") ]; then docker stop duke-builder; fi
	if [ ! -z $$(docker ps -a -q --filter "name=duke-builder") ]; then docker rm duke-builder; fi

remove-image: stop-and-remove-container
	if [ ! -z $$(docker images -q duke-builder) ]; then docker rmi -f duke-builder; fi

clean: remove-image
	
# Build the Duke ISO
all: move clean 