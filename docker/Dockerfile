FROM ruby:2.6.3

RUN apt-get update
RUN apt-get install -y build-essential libssl-dev autoconf bison libreadline7 libreadline-dev zlib1g zlib1g-dev

RUN gem install bundler -v 2.0

WORKDIR /usr/src/app
COPY Gemfile ./
COPY mumuki-laboratory.gemspec ./
COPY lib/mumuki/laboratory/version.rb lib/mumuki/laboratory/version.rb
# COPY lib/ lib/

RUN bundle install
COPY . .

EXPOSE 8080
# CMD ["rails", "server", "-b", "0.0.0.0"]
CMD sleep infinity