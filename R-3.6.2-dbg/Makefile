R_VERSION := 3.6.2
IMAGE_NAME_SUFFIX := -gdb

include ../Makefile.in

image:
# TODO generate the entryfile.sh based on the parameters here
	docker build \
    --rm \
    -t $(IMAGE) \
    --build-arg CFLAGS="-Wall -O0 -g3 -gdwarf-4 -DDEBUG" \
    $(IMAGE_BUILD_ARSG) \
    ../R-3.6.2
