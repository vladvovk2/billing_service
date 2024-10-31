FROM ruby:3.0

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

ENV APP_HOME /app
RUN mkdir /app
WORKDIR /app

RUN gem install bundler

COPY Gemfile* ./

RUN bundle install

COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0", "-p", "3000"]