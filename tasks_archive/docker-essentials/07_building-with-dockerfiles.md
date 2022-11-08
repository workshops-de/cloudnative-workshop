# Building Images with Dockerfiles
We often used prepared images to run nginx. Let's try to build our own nginx image from a base image. Start with `alpine:3.16.0` as base image, install nginx and configure nginx as default command of the container. Check the hints section if you have problems on the way.

If you finished your Dockerfile, use `docker build` to build it. Use `my-nginx` as image name.

## Run your container
Now you can start your own image with:
```
docker run -d -p 8080:80 my-nginx
```

Use the webpreview to verify if it is working.

## Cleanup
```
docker rm -f $(docker ps -qa)
```