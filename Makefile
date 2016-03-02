IMAGE_NAME := 'lukz/php-fpm'

# bins
DOCKER := $(shell which adocker || which docker)

all: build

build:
	${DOCKER} build -t ${IMAGE_NAME}:latest   7

build-no-cache:
	${DOCKER} build --rm --no-cache -t ${IMAGE_NAME}:latest   7		