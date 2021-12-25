FROM golang:latest as golang
RUN apt update
RUN apt install -y\
    git \
    pkgconf \
    libssh-dev \
    musl-dev \
    cmake \
    make \
    libfuture-perl \
    gcc \
    bash \
    libhttp-parser-dev  \
    libsqlite3-dev 
RUN wget https://github.com/libgit2/libgit2/archive/v1.3.0.tar.gz && \
    tar xzf v1.3.0.tar.gz && \
    cd libgit2-1.3.0/ && \
    cmake -DBUILD_CLAR=OFF . && \
    make && \
    make install 
RUN CGO_CFLAGS=-DUSE_LIBSQLITE3 CGO_LDFLAGS=-Wl,--unresolved-symbols=ignore-in-object-files go install -tags="sqlite_vtable,vtable,sqlite_json1,static,system_libgit2" github.com/mergestat/mergestat@latest
WORKDIR $GOPATH/src/xqledger/gitreader
COPY . ./
ADD https://github.com/golang/dep/releases/download/v0.5.0/dep-linux-amd64 /usr/bin/dep
ADD resources/application.yml ./
RUN CGO_ENABLED=0 go install -ldflags '-extldflags "-static"'
RUN apt update -y
RUN apt install libgit2-dev  -y
RUN apt autoremove -y
ENTRYPOINT ["/go/bin/gitreader"]