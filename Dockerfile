FROM golang:1.22-alpine AS builder

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY *.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o /rtsptohls .

FROM alpine:3.20

RUN apk add --no-cache ca-certificates tzdata

WORKDIR /app

COPY --from=builder /rtsptohls ./rtsptohls
COPY web ./web
COPY config.example.json ./config.json

EXPOSE 8083

CMD ["./rtsptohls"]
