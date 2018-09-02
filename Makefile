PROJECT_NAME ?= ss4

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
	docker-compose -f $(TEST_COMPOSE_FILE) kill
	docker-compose -f $(TEST_COMPOSE_FILE) rm -f