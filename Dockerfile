FROM ruby:2.6.6-alpine

MAINTAINER Darren Oakley <daz.oakley@gmail.com>

RUN apk add --update --no-cache build-base ruby-dev libxml2-dev libxslt-dev postgresql-dev mysql-dev openssl ca-certificates wget && \
  update-ca-certificates

RUN gem install bundler

RUN addgroup bandiera && adduser -D -G bandiera -h /home/bandiera bandiera

WORKDIR /home/bandiera

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle config set without 'test' \
  && bundle install --retry 10 --jobs 4 --without test

COPY . .

USER bandiera

ENV prometheus_multiproc_dir=/tmp/prometheus_multiproc_dir
RUN mkdir ${prometheus_multiproc_dir}

EXPOSE 5000

CMD ["puma"]
