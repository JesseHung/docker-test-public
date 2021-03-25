FROM ruby:2.6.3
MAINTAINER jessie <yingcianhung0625@gmail.com>
RUN apt-get update && apt-get install -y build-essential libpq-dev nodejs vim postgis imagemagick
RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN gem install bundler
RUN bundle --version
RUN bundle install
RUN rails db:create rails db:migrate rails db:seed:20210325_create_user
RUN rails s 