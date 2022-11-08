# Layer Caching

## Inspect and build
Inspect the files in this task.

Build the image with:
```
docker build -t node-app:1.0.0 .
docker run -it --rm -p 8080:80 node-app:1.0.0
```
You can access the app by using the Webpreview

## Release a new version
Now we want to see what happens if we release a new version. We simulate that by changing the message that the app outputs. Go into `main.js` and change the string in variable `message`.

Now build a new version of it:
```
docker build -t node-app:1.1.0 .
```
Hmm, we just changed the message but the dependencies needed to be installed completely again. Why is that? And can we change it?

## Refactor Dockerfile
Separate dependency installation into its own step. Do do that first only copy dependency related files into the cointainer, then install dependencies, and after that bring your sourcecode into the container.

With this change we can want to observe the scenario again. Since we did major changes to the Dockerfile we need to build an inital version of it:
```
docker build -t node-app:2.0.0 .
```
If you want, run it and see if it still works

Now let's do a new release again. Change the message and create a new version
```
docker build -t node-app:2.1.0 .
```

Which changes did you observe?

## Cleanup
```
docker rm -f $(docker ps -qa)
```