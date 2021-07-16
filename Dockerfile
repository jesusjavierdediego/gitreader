# FROM golang:alpine as golang
# RUN apk update
# RUN apk add --no-cache \
#     alpine-sdk \
#     pkgconf \
#     libgit2-dev \
#     libssh2-dev \
#     musl-dev \
#     cmake \
#     make \
#     perl-utils \
#     gcc \
#     bash \
#     http-parser-dev \
#     git

# RUN go get -v -tags=sqlite_vtable github.com/augmentable-dev/askgit
# WORKDIR $GOPATH/src/xqledger/gitreader
# COPY . ./
# ADD https://github.com/golang/dep/releases/download/v0.5.0/dep-linux-amd64 /usr/bin/dep
# ADD resources/application.yml ./
# RUN CGO_ENABLED=0 go install -ldflags '-extldflags "-static"'
# RUN apk --no-cache add tzdata zip ca-certificates
# WORKDIR /usr/share/zoneinfo
# RUN zip -r -0 /zoneinfo.zip .
# ENV ZONEINFO /zoneinfo.zip
# RUN apk add --update openssl && \
#     rm -rf /var/cache/apk/*

# COPY resources/application.yml /application.yml

# ENTRYPOINT ["/go/bin/gitreader"]



FROM golang:alpine as golang
# RUN apk add --no-cache git
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
    git
RUN go get -v -tags=sqlite_vtable github.com/augmentable-dev/askgit
WORKDIR $GOPATH/src/xqledger/gitreader
COPY . ./
ADD https://github.com/golang/dep/releases/download/v0.5.0/dep-linux-amd64 /usr/bin/dep
ADD resources/application.yml ./
RUN CGO_ENABLED=0 go install -ldflags '-extldflags "-static"'

FROM alpine:latest as alpine
RUN apk --no-cache add tzdata zip ca-certificates
WORKDIR /usr/share/zoneinfo
RUN zip -r -0 /zoneinfo.zip .

FROM scratch
COPY --from=golang /go/bin/gitreader /app
COPY --from=golang /go/src/xqledger/gitreader/resources/application.yml ./
ENV ZONEINFO /zoneinfo.zip
COPY --from=alpine /zoneinfo.zip /
COPY --from=alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["/app"]