FROM golang:alpine as golang
RUN apk add --no-cache git
RUN apk update
RUN apk add --no-cache \
    alpine-sdk \
    pkgconf \
    libgit2-dev \
    libssh2-dev \
    musl-dev \
    cmake \
    make \
    perl-utils \
    gcc \
    bash \
    http-parser-dev \
    git \
    sqlite-dev
RUN CGO_CFLAGS=-DUSE_LIBSQLITE3 CGO_LDFLAGS=-Wl,--unresolved-symbols=ignore-in-object-files go install -tags="sqlite_vtable,vtable,sqlite_json1,static,system_libgit2" github.com/askgitdev/askgit@latest

WORKDIR $GOPATH/src/xqledger/gitreader
COPY . ./
ADD https://github.com/golang/dep/releases/download/v0.5.0/dep-linux-amd64 /usr/bin/dep
ADD resources/application.yml ./
RUN CGO_ENABLED=0 go install -ldflags '-extldflags "-static"'
RUN echo "ASKGIT:"
RUN echo which askgit
# COPY $GOPATH/src/xqledger/gitreader /
ENTRYPOINT ["/go/bin/gitreader"]

# FROM alpine:latest as alpine
# RUN apk --no-cache add tzdata zip ca-certificates
# WORKDIR /usr/share/zoneinfo
# RUN zip -r -0 /zoneinfo.zip .

# FROM scratch
# COPY --from=golang /go/bin/gitreader /app
# COPY --from=golang /go/src/xqledger/gitreader/resources/application.yml ./
# ENV ZONEINFO /zoneinfo.zip
# COPY --from=alpine /zoneinfo.zip /
# COPY --from=alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
# ENTRYPOINT ["/app"]