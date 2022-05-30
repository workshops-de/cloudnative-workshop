FROM ubuntu:20.04
RUN mkdir /data
ENTRYPOINT [ "/bin/sh", "-c", "while true; do echo $(date) >> /data/file.txt; sleep 10; done;" ]
