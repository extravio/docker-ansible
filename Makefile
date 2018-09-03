PROJECT_NAME ?= ss4
ORG_NAME ?= mm
REPO_NAME ?= ss4

# Filenames
TEST_COMPOSE_FILE := docker/test/docker-compose.yml

# Docker Compose Project Names
TEST_PROJECT := $(PROJECT_NAME)$(BUILD_ID)

.PHONY: test build clean

test:
	docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) build
	docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) up ss4test
	docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) down
	
build:
	docker build -t ss4prod -f ./docker/prod/Dockerfile .
	
clean:
	${INFO} "Destroying development environment..."
	@ docker-compose -f $(TEST_COMPOSE_FILE) kill
	@ docker-compose -f $(TEST_COMPOSE_FILE) rm -f -v
	@ docker images -q -f dangling=true -f label=application=$(REPO_NAME) | xargs -I ARGS docker rmi -f ARGS
	${INFO} "Clean complete"

# Cosmetics
YELLOW := "\e[1;33m"
NC := "\e[0m"

# Shell Functions
INFO := @bash -c '\
	printf $(YELLOW); \
	echo "=> $$1"; \
	printf $(NC)' VALUE