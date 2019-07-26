IMAGE_TAG=cloudbees/cjd-jcasc-demo
DEVEL_SUFFIX=devel
IMAGE_DEVEL_TAG=${IMAGE_TAG}:${DEVEL_SUFFIX}
INCLUDE_ALL_BUNDLED_PLUGINS?=true
DOCKER_BUILD_FLAGS?=

clean:
	@if docker images ${IMAGE_TAG} | awk '{ print $$2 }' | grep -q -F ${IMAGE_DEVEL_TAG}; then docker image rm --force ${IMAGE_DEVEL_TAG} ; false; fi

build:
	docker build -t ${IMAGE_TAG}:rolling ${DOCKER_BUILD_FLAGS} .

run:
	docker run -u root --rm -p 8080:8080 -p 50000:50000 \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-e JAVA_OPTS="-Dcom.cloudbees.jenkins.cjp.installmanager.CJPPluginManager.allRequired=${INCLUDE_ALL_BUNDLED_PLUGINS}" \
		${IMAGE_TAG}

run-devel:
	rm -rf work
	mkdir work
	docker run -u root --rm -p 8080:8080 -p 50000:50000 \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-e JAVA_OPTS="-Dcom.cloudbees.jenkins.cjp.installmanager.CJPPluginManager.allRequired=${INCLUDE_ALL_BUNDLED_PLUGINS}" \
		-e VERBOSE=true \
		-v $(CURDIR)/work:/var/jenkins_home/ \
		${IMAGE_DEVEL_TAG}
