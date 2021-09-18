FROM augmentable/askgit:latest as askgit
RUN apt-get update
RUN apt-get install -y git && apt-get install -y wget
RUN wget https://dl.google.com/go/go1.17.1.linux-amd64.tar.gz 
RUN tar -xvf go1.17.1.linux-amd64.tar.gz   
RUN mv go /usr/local  
ENV GOROOT /usr/local/go 
ENV GOPATH /apps 
ENV PATH $GOPATH/bin:$GOROOT/bin:$PATH 
WORKDIR $GOPATH/src/xqledger/gitreader
COPY . ./
ADD resources/application.yml ./
RUN CGO_ENABLED=0 go install -ldflags '-extldflags "-static"'

FROM alpine:latest as alpine
RUN apk --no-cache add tzdata zip ca-certificates
WORKDIR /usr/share/zoneinfo
RUN zip -r -0 /zoneinfo.zip .

FROM scratch
COPY --from=askgit /apps/bin/gitreader /app
COPY --from=askgit /apps/src/xqledger/gitreader/resources/application.yml ./
ENV ZONEINFO /zoneinfo.zip
COPY --from=alpine /zoneinfo.zip /
COPY --from=alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["/app"]


