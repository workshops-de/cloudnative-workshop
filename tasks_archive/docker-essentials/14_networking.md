# Networking

## List networks
First let's take a look at the pre-installed networks:
```
docker network ls
```

## Host Network
We haved used the default bridge quite a lot, but we didn't use the host network yet:
```
docker run -d --net host --name host-net nginxinc/nginx-unprivileged
```

We use `nginx-unprivileged` here because it binds on port 8080 instead of 80. Port 80 is not available in the Webpreview.
Try to access this container on host port 8080.

## Work with custom network
```
# Create new network
docker network create my-network

# List networks
docker network ls

# Run webserver in network
docker run -d --net my-network --name webserver nginx:1.23.0

# Create a container that talks to the webserver
docker run -it --rm --net my-network curlimages/curl:7.83.1 webserver

# Replace webserver with a variant that has a network-alias
docker rm -f webserver
docker run -d --net my-network --name webserver --net-alias my-nginx nginx:1.23.0

docker run -it --rm --net my-network curlimages/curl:7.83.1 my-nginx

# What happens when we are not in the same network? Try curl from the default bridge
docker run -it --rm curlimages/curl:7.83.1 my-nginx
```

## Cleanup
```
docker rm -f $(docker ps -qa)
```