#!/bin/sh

TAG=${1:-"php-fpm74"}

docker build -f Dockerfile --tag ${TAG}:latest .

