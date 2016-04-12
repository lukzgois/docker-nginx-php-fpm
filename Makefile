BUILD_NAME := 'local/nginx-php-fpm-local'

# bins
DOCKER := $(shell which adocker || which docker)

all: build

build:
	${DOCKER} build -t ${BUILD_NAME}:latest   7

build-no-cache:
	${DOCKER} build --rm --no-cache -t ${BUILD_NAME}:latest   7		