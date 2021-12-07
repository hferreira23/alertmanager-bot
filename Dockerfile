FROM golang:alpine AS build-env

RUN apk --no-cache add build-base git

WORKDIR /go

RUN git clone --depth 1 https://github.com/metalmatze/alertmanager-bot.git

WORKDIR /go/alertmanager-bot

RUN make

FROM alpine:edge
ENV TEMPLATE_PATHS=/templates/default.tmpl
RUN apk add --update ca-certificates tini && \
    apk upgrade --available && \
    rm -rf /tmp/* /var/tmp/* /var/cache/*

COPY --from=build-env /go/alertmanager-bot/default.tmpl /templates/default.tmpl
COPY --from=build-env /go/alertmanager-bot/alertmanager-bot /usr/bin/alertmanager-bot

USER nobody

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/usr/bin/alertmanager-bot"]
