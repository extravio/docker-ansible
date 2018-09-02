# Build test image

~/dev/cd/docker-ansible$ 
> docker build -t ss4test -f ./docker/test/Dockerfile .

> docker run --rm -i -t ss4test

> docker-compose up ss4test

depends_on doesn't wait until the mariadb container is "ready"

for a more robust solution, add a wrapper script as described here:

https://docs.docker.com/compose/startup-order/


# caching

Create volume container

> docker run -v /tmp/cache:/cache --entrypoint true --name composer ss4test