FROM alpine:edge
ENV TEMPLATE_PATHS=/templates/default.tmpl
RUN apk add --update ca-certificates && \
    apk upgrade --available && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

COPY ./default.tmpl /templates/default.tmpl
COPY ./alertmanager-bot /usr/bin/alertmanager-bot

ENTRYPOINT ["/usr/bin/alertmanager-bot"]
