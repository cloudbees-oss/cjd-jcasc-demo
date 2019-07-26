IMAGE_TAG=cloudbees/cjd-jcasc-demo
DEVEL_SUFFIX=devel
IMAGE_DEVEL_TAG=${IMAGE_TAG}:${DEVEL_SUFFIX}
DOCKER_BUILD_FLAGS?=

clean:
	@if docker images ${IMAGE_TAG} | awk '{ print $$2 }' | grep -q -F ${IMAGE_DEVEL_TAG}; then docker image rm --force ${IMAGE_DEVEL_TAG} ; false; fi

build:
	docker build -t ${IMAGE_DEVEL_TAG} ${DOCKER_BUILD_FLAGS} .

run:
	docker run --rm -p 8080:8080 ${IMAGE_TAG}

run-devel:
	rm -rf work
	mkdir work
	docker run --rm -p 8080:8080 \
		-e VERBOSE=true \
		-v $(CURDIR)/work:/var/jenkins_home/ \
		${IMAGE_DEVEL_TAG}
