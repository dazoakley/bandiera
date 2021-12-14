FROM ruby:3.0.3-alpine

LABEL org.opencontainers.image.authors="Darren Oakley <daz.oakley@gmail.com>"

ARG VERSION=local
ENV VERSION=${VERSION}
ARG REVISION=gitsha
ENV REVISION=${REVISION}
ARG BUILDTIME=buildtime
ENV BUILDTIME=${BUILDTIME}

RUN apk update && \
  apk upgrade && \
  apk add build-base ruby-dev libxml2-dev libxslt-dev postgresql-dev mysql-dev openssl ca-certificates wget && \
  update-ca-certificates && \
  rm -rf /var/cache/apk/*

RUN gem install bundler

RUN addgroup -S -g 2000 bandiera && \
  adduser -S -u 2000 -D -G bandiera -h /home/bandiera bandiera

WORKDIR /home/bandiera

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle config set --local without 'test' && \
  bundle config set --local deployment 'true' && \
  bundle config set --local bin /home/bandiera/bin && \
  bundle config set --local frozen 'true' && \
  bundle install --jobs 4

COPY . .

USER bandiera

ENV RACK_ENV=production

EXPOSE 5000

CMD ["./entrypoint.sh"]
