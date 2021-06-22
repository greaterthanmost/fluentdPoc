FROM fluent/fluentd:latest

# Use root account to use apk
USER root

RUN addgroup -S fluent && adduser -S -g fluent fluent

# below RUN includes plugin as examples elasticsearch is not required
# you may customize including plugins as you wish
RUN apk add --no-cache --update --virtual .build-deps \
        sudo build-base ruby-dev \
 && apk add --no-cache curl \
 && sudo gem install fluent-plugin-elasticsearch \
 && sudo gem install fluent-plugin-dynatrace \
 && sudo gem install fluent-plugin-json \
 && sudo gem install fluent-plugin-rewrite-tag-filter \
 && sudo gem install fluent-plugin-cloudwatch-logs \
 && sudo gem sources --clear-all \
 && apk del .build-deps \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

COPY configs/*fluent.conf /fluentd/etc/
COPY entrypoint.sh /bin/

USER fluent