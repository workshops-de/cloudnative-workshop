FROM golang:1.18.0-alpine3.14
RUN mkdir /build
ADD main.go go.mod /build/
WORKDIR /build
RUN CGO_ENABLED=0 GOOS=linux go build -o main .
ENTRYPOINT [ "./main" ]
