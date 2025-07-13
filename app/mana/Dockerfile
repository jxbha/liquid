ARG REGISTRY=localhost
FROM "$REGISTRY"/alpine:3.20
WORKDIR /app
COPY mana .
EXPOSE 4040
CMD [ "sh", "-c","./mana"]
