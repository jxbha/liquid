FROM golang:1.23 AS builder
WORKDIR /build
COPY . .
RUN CGO_ENABLED=0 go build -o mana ./cmd/

#FROM alpine
FROM alpine

WORKDIR /app
COPY --from=builder /build/mana .

EXPOSE 4040
CMD ["./mana"]
