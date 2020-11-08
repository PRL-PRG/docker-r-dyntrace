IMAGE_NAME := prlprg/r-dyntrace
VERSION    ?= r-4.0.2

.PHONY: image image-upload

all: image

image:
	docker build \
    --build-arg VERSION="$(VERSION)" \
    --rm \
    -t $(IMAGE_NAME) \
    .

image-upload: image
	docker push $(IMAGE_NAME)
