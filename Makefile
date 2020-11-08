VERSION    ?= r-4.0.2
IMAGE_NAME := prlprg/r-dyntrace:$(VERSION)

.PHONY: image upload

all: image

image:
	docker build \
    --build-arg VERSION="$(VERSION)" \
    --rm \
    -t $(IMAGE_NAME) \
    .

upload: image
	docker push $(IMAGE_NAME)
