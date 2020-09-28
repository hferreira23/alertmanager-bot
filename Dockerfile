FROM golang:alpine AS build-env

RUN apk --no-cache add build-base

COPY ./cmd /
COPY Makefile /
COPY go* /

RUN make

FROM alpine:edge
ENV TEMPLATE_PATHS=/templates/default.tmpl
RUN apk add --update ca-certificates && \
    apk upgrade --available && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

COPY ./default.tmpl /templates/default.tmpl
COPY --from=build-env ./alertmanager-bot /usr/bin/alertmanager-bot

ENTRYPOINT ["/usr/bin/alertmanager-bot"]
