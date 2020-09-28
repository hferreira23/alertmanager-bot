FROM golang:alpine AS build-env

RUN apk --no-cache add build-base git

WORKDIR /go

RUN git clone --depth 1 https://github.com/hferreira23/alertmanager-bot.git

WORKDIR /go/alertmanager-bot

RUN make

FROM alpine:edge
ENV TEMPLATE_PATHS=/templates/default.tmpl
RUN apk add --update ca-certificates && \
    apk upgrade --available && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

COPY ./default.tmpl /templates/default.tmpl
COPY --from=build-env /go/alertmanager-bot/alertmanager-bot /usr/bin/alertmanager-bot

ENTRYPOINT ["/usr/bin/alertmanager-bot"]
