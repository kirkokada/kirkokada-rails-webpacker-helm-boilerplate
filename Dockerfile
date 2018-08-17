FROM ruby:latest as build
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn
ENV APP_DIR=/app
RUN mkdir -p $APP_DIR
WORKDIR $APP_DIR
ADD Gemfile Gemfile.lock $APP_DIR/
RUN bundle install --deployment --jobs=4
# Useless at the moment, will hopefully be fixed soon
ADD package.json yarn.lock $APP_DIR/
RUN yarn install
ADD . $APP_DIR
RUN RAILS_ENV=production bundle exec rake assets:precompile
RUN rm -rf $APP_DIR/node_modules
RUN rm -rf $APP_DIR/tmp/*

FROM ruby:slim
# Install whatever system packages you need
RUN apt-get update && apt-get -y install libpq5
RUN mkdir -p /app
WORKDIR /app
COPY --from=build /app /app
RUN bundle config --local path vendor/bundle
RUN bundle config --local
CMD bundle exec rails server
