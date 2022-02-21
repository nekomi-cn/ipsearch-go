FROM golang:1.17 as builder
RUN mkdir -p /go/src/
WORKDIR /go/src/
ADD . /go/src/
RUN cd cmd; \
        export GOPROXY=https://goproxy.io,direct; \
        CGO_ENABLE=0 GOOS=linux go build -o app .
FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /go/src/cmd/app .
COPY ./web/ web/
EXPOSE 8080
CMD [ "./app" ]
