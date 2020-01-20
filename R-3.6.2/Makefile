R_VERSION := 3.6.2

include ../Makefile.in

image:
# TODO generate the entryfile.sh based on the parameters here
	docker build \
    --rm \
    -t $(IMAGE) \
    $(IMAGE_BUILD_ARSG) \
    .
