FROM golang:1.19 AS build
COPY . /go/src/nats-kafka
WORKDIR /go/src/nats-kafka
ARG VERSION
RUN VERSION=$VERSION make nats-kafka.docker

FROM alpine:latest as osdeps
RUN apk add --no-cache ca-certificates

LABEL maintainer "Wally Quevedo <wally@nats.io>"
LABEL maintainer "Ivan Kozlovic <ivan@nats.io>"
LABEL maintainer "Stephen Asbury <sasbury@nats.io>"
LABEL maintainer "Jaime Piña <jaime@nats.io>"

FROM scratch
COPY --from=build /go/src/nats-kafka/nats-kafka.docker /bin/nats-kafka
COPY --from=osdeps /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

ENTRYPOINT ["/bin/nats-kafka"]
