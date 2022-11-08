# Volumes
In this task we will learn how to persist data.

## Inspect and build
```
docker build -t volumes:1.0.0 .
```

## Container Layer
First version only writes into the container layer which is bound to the container's lifecycle
```
# Create the container
docker run -d --name container-layer volumes:1.0.0

# Printout the content of the file
docker exec -it container-layer cat /data/file.txt

# Stop the container
docker stop container-layer

# Restart the container
docker start container-layer

# Printout the content of the file again
# Note that the file contains the timestamps from the first run
docker exec -it container-layer cat /data/file.txt

# Remove the container
# Note that all changes get lost
docker rm -f container-layer
```

## Docker Volume
Let's try the same with a Docker Volume
```
# Create the container
docker run -d --name volume -v /data volumes:1.0.0

# Printout the content of the file
docker exec -it volume cat /data/file.txt

# Cleanup all pre-existing volumes
# Note that Docker will not delete volumes of running containers
docker volume prune

# List all volumes
docker volume ls

# Show the details of the volume via `volume inspect`
docker volume inspect <VOLUME-NAME>

# Show the details of the volume via `inspect`
docker inspect volume | grep -A10 Mounts


# Printout the content of the file
sudo cat <HOST-VOLUME-PATH>/file.txt

# Delete the container
docker rm -f volume

# List the volumes
# Note that the volume is not deleted yet
docker volume ls

# Cleanup all volumes
docker volume prune

# Try to printout the content of the file
# Note that the file does not exist anymore
sudo cat <HOST-VOLUME-PATH>/file.txt
```

## Bind-mount
```
# Create the container
docker run -d --name bind-mount -v $PWD/data:/data volumes:1.0.0

# Check the content of the file `file.txt` in the folder `data` in your current directory
cat data/file.txt

# Printout the volumes
# Note that the volume is not managed by docker
docker volume ls

# Delete the container
docker rm -f bind-mount

# Cleanup all volumes
docker volume prune

# Check the content of the file `file.txt` again
# Note that the file still exists
cat data/file.txt
```