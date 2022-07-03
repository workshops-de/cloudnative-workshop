FROM alpine:3.16.0
RUN mkdir /data
ENTRYPOINT [ "/bin/sh", "-c", "while true; do echo $(date) >> /data/file.txt; sleep 10; done;" ]