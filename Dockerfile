FROM golang:1.9-alpine3.7 as builder

RUN apk add --update curl gcc musl-dev && \
    cd /tmp && \
    mkdir -p /go/src/github.com/kelseyhightower && \
    curl -SsL https://api.github.com/repos/kelseyhightower/confd/tarball/master | tar -xz && \
    cp -Rf /tmp/kelseyhightower-confd-* /go/src/github.com/kelseyhightower/confd

WORKDIR /go/src/github.com/kelseyhightower/confd

RUN go get ./... && \
    go build -a -ldflags '-extldflags "-static"' -o bin/confd .

FROM alpine:3.7

RUN mkdir -p /etc/confd

COPY --from=builder /go/src/github.com/kelseyhightower/confd/bin/confd /opt/bin/confd

ENTRYPOINT ["/opt/bin/confd"]
