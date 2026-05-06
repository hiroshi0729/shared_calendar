FROM ruby:3.2.3
ENV LANG C.UTF-8
ENV TZ Asia/Tokyo

RUN apt-get update -qq \
  && apt-get install -y ca-certificates curl gnupg \
  && mkdir -p /etc/apt/keyrings \
  && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
  && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
  && apt-get update -qq \
  && apt-get install -y build-essential libpq-dev nodejs postgresql-client \
  && npm install -g yarn@1.22.22

RUN mkdir /shared_calendar
WORKDIR /shared_calendar

RUN gem install bundler:2.3.17

COPY Gemfile /shared_calendar/Gemfile
COPY Gemfile.lock /shared_calendar/Gemfile.lock
RUN bundle install

COPY . /shared_calendar

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# サーバーのPIDファイルを削除してから起動
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails s -b '0.0.0.0'"]