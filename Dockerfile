FROM ruby:3.1.2


RUN apt-get update -qq && apt-get install -y \
  nodejs \
  postgresql-client \
  curl \
  unzip \
  fonts-liberation \
  libappindicator3-1 \
  libasound2 \
  libatk-bridge2.0-0 \
  libatk1.0-0 \
  libcups2 \
  libdbus-1-3 \
  libgdk-pixbuf2.0-0 \
  libnspr4 \
  libnss3 \
  libx11-xcb1 \
  libxcomposite1 \
  libxdamage1 \
  libxrandr2 \
  xdg-utils \
  --no-install-recommends && \
  rm -rf /var/lib/apt/lists/*

# Install Chrome
RUN curl -sSL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /tmp/chrome.deb && \
  apt-get update -qq && \
  apt-get install -y /tmp/chrome.deb && \
  rm /tmp/chrome.deb

# Install chromedriver
RUN curl -sSL https://chromedriver.storage.googleapis.com/114.0.5735.90/chromedriver_linux64.zip -o /tmp/chromedriver.zip && \
  unzip /tmp/chromedriver.zip -d /usr/local/bin/ && \
  rm /tmp/chromedriver.zip

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN bundle install

COPY . /app

EXPOSE 3000

CMD ["bash", "-c", "bundle exec rake db:migrate && bundle exec puma -C config/puma.rb"]