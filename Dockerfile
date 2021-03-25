FROM golang:1.16-buster as compile-image

WORKDIR /app

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

FROM scratch

COPY --from=compile-image /app/app /

ENV BOT_TOKEN=token
ENV APP_ID=12345
ENV APP_HASH=hash

CMD ["/app"]
