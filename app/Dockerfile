FROM golang:1.20 AS builder
WORKDIR /build
COPY . .
RUN go mod tidy
RUN CGO_ENABLED=0 go build -o mana .

#FROM alpine
FROM alpine

WORKDIR /app
COPY --from=builder /build/mana .

EXPOSE 4040
ENV	POSTGRES_UN=$POSTGRES_UN
ENV	POSTGRES_PW=$POSTGRES_PW
ENV	POSTGRES_URI=$POSTGRES_URI

RUN chmod +x mana
CMD ["./mana"]
