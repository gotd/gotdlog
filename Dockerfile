# syntax=docker/dockerfile:1.2.1

FROM golang:1.16.3-alpine3.13 as builder
ENV GOFLAGS='-trimpath -mod=readonly'
ENV CGO_ENABLED=0
ENV GO_EXTLINK_ENABLED=0
WORKDIR /app
COPY . .
RUN \
    --mount=type=cache,id=gocache,target=/root/.cache/go-build \
    --mount=type=cache,id=gomodcache,target=/go/pkg \
    go install

FROM scratch
COPY --from=builder /go/bin /bin
ENV BOT_TOKEN=token
ENV APP_ID=12345
ENV APP_HASH=hash
CMD ["/app"]
