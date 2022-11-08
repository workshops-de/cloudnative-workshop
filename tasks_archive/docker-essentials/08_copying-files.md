# Copying files
In this task we will bring our own code into an image.
We will use a webserver and include our own HTML template.

## Preparation
This is the first task that uses predefined Dockerfiles. First we need to clone the Workshop repository.
```
git clone https://github.com/workshops-de/cloudnative-workshop.git
```
Then we need to navigate to the correct folder of the repository. For this task run:
```cd cloudnative-workshop/docker-essentials/08_copy-files```
You can also use the editor panel of the Gloud Shell to view the files.

## Build the image
Take a look at the Dockerfile. The instruction that brings in our `index.html` is missing.
Can you figure out which instruction needs to be added to the Dockerfile?
By default the images serves files from `/usr/share/nginx/html` within the container.

```
docker build -t webserver:1.0.0 .
```

## Start a container
You can start a container and validate the result by using the Webpreview
```docker run -d -p 8080:80 webserver:1.0.0```

## Cleanup
```
docker rm -f $(docker ps -qa)
```