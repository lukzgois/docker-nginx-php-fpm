IMAGE_NAME := 'lukz/php-fpm'

# bins
DOCKER := $(shell which docker)

all: build

build:
	${DOCKER} build -t ${IMAGE_NAME}:latest   7