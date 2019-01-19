FROM ruby:2.5.3

RUN apt-get update && apt-get install -y build-essential libpq-dev postgresql-client

RUN mkdir /slack-oauth-app
WORKDIR /slack-oauth-app
COPY Gemfile /slack-oauth-app/Gemfile
COPY Gemfile.lock /slack-oauth-app/Gemfile.lock
RUN bundle install
COPY . /slack-oauth-app