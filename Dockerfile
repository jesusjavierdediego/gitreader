FROM golang:alpine as golang
RUN apk add --no-cache git
RUN apk update
RUN apk add --no-cache \
    alpine-sdk \
    pkgconf \
    # libgit2-dev \
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
RUN wget https://github.com/libgit2/libgit2/archive/v1.3.0.tar.gz && \
    tar xzf v1.3.0.tar.gz && \
    cd libgit2-1.3.0/ && \
    cmake -DBUILD_CLAR=OFF . && \
    make && \
    make install 
RUN CGO_CFLAGS=-DUSE_LIBSQLITE3 CGO_LDFLAGS=-Wl,--unresolved-symbols=ignore-in-object-files go install -tags="sqlite_vtable,vtable,sqlite_json1,static,system_libgit2" github.com/askgitdev/askgit@latest
WORKDIR $GOPATH/src/xqledger/gitreader
COPY . ./
ADD https://github.com/golang/dep/releases/download/v0.5.0/dep-linux-amd64 /usr/bin/dep
ADD resources/application.yml ./
RUN CGO_ENABLED=0 go install -ldflags '-extldflags "-static"'
ENTRYPOINT ["/go/bin/gitreader"]