# Exposing ports
We started multiple webservers but we haven't seen any webpage yet. Isn't that the purpose of a webserver? Let's change that!

## Start container
To access the page that the webserver delivers we need to expose the port that the server is listening on
```
docker run -d -p 8080:80 nginxdemos/hello
```

## Visit the page
The Google Cloud Shell does not have a public IP. But we can use the Webpreview feature to make a single port viewable from the outside. Use the webpreview button on the top right for that.

## Could this also be done with `-P`?
Let's try!
```docker run -d -P nginxdemos/hello```
Seems to work. But on which port can we now reach this container? Try to find out!

## Cleanup
```
docker rm -f $(docker ps -qa)
```
