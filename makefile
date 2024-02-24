# Makefile for DebianDuke

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
build: copy-config
	docker exec -t duke-builder /bin/bash -c "cd /duke && lb clean && lb config && lb build"

# Copy the Duke ISO out of the Duke Builder Container & Copy build logs & generated config files
move: build
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