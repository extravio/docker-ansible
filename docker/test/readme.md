# Build test image

~/dev/cd/docker-ansible$ 
> docker build -t ss4test -f ./docker/test/Dockerfile .

> docker run --rm -i -t ss4test

Force docker-compose to rebuild any images that are configured to be built.

> docker-compose build

> docker-compose up ss4test

depends_on doesn't wait until the mariadb container is "ready"

for a more robust solution, add a wrapper script as described here:

https://docs.docker.com/compose/startup-order/


# caching

Create volume container

> docker run -v /tmp/cache:/cache --entrypoint true --name composer ss4test


# clean up

> docker-compose kill

> docker-compose rm -f

# copy from docker to host

> docker cp $$(docker-compose -p $(DEV_PROJECT) -f (DEV_COMPOSE_FILE) ps -q builder):/wheelhouse/. target

> docker-compose rm -f

# handling errors

> docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) up ss4test

Always exists with code 0 even if a test fails. Use run -rm:

> docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) run -rm ss4test

However, we still need to copy the files (coverage report) which we cannot do with docker-compose run -rm
because the container is automatically deleted. (We have to use the rm flag because docker-compose kill / rm don't recognise containers started with run)

# image consistency

docker-compose pull will pull the latest images for services based on images. 
For services built dynamically, we would need to pull the latest image by using the 
--pull flag with the build command.

If the php72-dev had been published to Docker hub, we would need to add the following to the Makefile:

docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) build --pull ss4test

# tag Docker image
> make tag 0.1 latest $(git rev-parse --short HEAD)