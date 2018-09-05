PROJECT_NAME ?= ss4
ORG_NAME ?= mm
REPO_NAME ?= ss4

DOCKER_REGISTRY ?= docker.io

# Application Service Name - must match Docker Compose release specification application service name
APP_SERVICE_NAME := ss4test

# Filenames
TEST_COMPOSE_FILE := docker/test/docker-compose.yml

# Docker Compose Project Names
TEST_PROJECT := $(PROJECT_NAME)$(BUILD_ID)

# Check and Inspect Logic
INSPECT := $$(docker-compose -p $$1 -f $$2 ps -q $$3 | xargs -I ARGS docker inspect -f "{{ .State.ExitCode }}" ARGS)

# Shell Functions
CHECK := @bash -c '\
	if [[ $(INSPECT) -ne 0 ]]; \
	then exit $(INSPECT); fi' VALUE

.PHONY: test build clean tag buildtag

test:
	${INFO} "Pulling latest images..."
	docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) pull
	${INFO} "Building images..."
	docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) build ss4test
	${INFO} "Running tests..."
	docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) up ss4test
	docker cp $$(docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) ps -q ss4test):/tmp/coverage.xml reports/
	${CHECK} $(TEST_PROJECT) $(TEST_COMPOSE_FILE) ss4test
	${INFO} "Testing complete"
	
build:
	docker build -t ss4prod -f ./docker/prod/Dockerfile .
	
clean:
	${INFO} "Destroying development environment..."
	@ docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) down -v
	@ docker images -q -f dangling=true -f label=application=$(REPO_NAME) | xargs -I ARGS docker rmi -f ARGS
	${INFO} "Clean complete"

tag: 
	${INFO} "Tagging release image with tags $(TAG_ARGS)..."
	@ $(foreach tag,$(TAG_ARGS), docker tag $(IMAGE_ID) $(DOCKER_REGISTRY)/$(ORG_NAME)/$(REPO_NAME):$(tag);)
	${INFO} "Tagging complete"

# Cosmetics
YELLOW := "\e[1;33m"
NC := "\e[0m"

# Shell Functions
INFO := @bash -c '\
	printf $(YELLOW); \
	echo "=> $$1"; \
	printf $(NC)' VALUE

# Get container id of application service container
APP_CONTAINER_ID := $$(docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) ps -q $(APP_SERVICE_NAME))

# Get image id of application service
#IMAGE_ID := $$(docker inspect -f '{{ .Image }}' $(APP_CONTAINER_ID))
IMAGE_ID := ss4test

# Extract build tag arguments
ifeq (buildtag,$(firstword $(MAKECMDGOALS)))
	BUILDTAG_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  ifeq ($(BUILDTAG_ARGS),)
  	$(error You must specify a tag)
  endif
  $(eval $(BUILDTAG_ARGS):;@:)
endif

# Extract tag arguments
ifeq (tag,$(firstword $(MAKECMDGOALS)))
  TAG_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  ifeq ($(TAG_ARGS),)
    $(error You must specify a tag)
  endif
  $(eval $(TAG_ARGS):;@:)
endif