[![Stories in Ready](https://badge.waffle.io/mumuki/mumuki-atheneum.png?label=ready&title=Ready)](https://waffle.io/mumuki/mumuki-atheneum)
[![Build Status](https://travis-ci.org/mumuki/mumuki-atheneum.svg?branch=master)](https://travis-ci.org/mumuki/mumuki-atheneum)
[![Code Climate](https://codeclimate.com/github/mumuki/mumuki-atheneum/badges/gpa.svg)](https://codeclimate.com/github/mumuki/mumuki-atheneum)
[![Test Coverage](https://codeclimate.com/github/mumuki/mumuki-atheneum/badges/coverage.svg)](https://codeclimate.com/github/mumuki/mumuki-atheneum)
[![Issue Count](https://codeclimate.com/github/mumuki/mumuki-atheneum/badges/issue_count.svg)](https://codeclimate.com/github/mumuki/mumuki-atheneum)

Mumuki Atheneum [![btn_donate_lg](https://cloud.githubusercontent.com/assets/1039278/16535119/386d7be2-3fbb-11e6-9ee5-ecde4cef142a.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=KCZ5AQR53CH26)
================

> Code assement web application for the Mumuki platform

## About

Atheneum is a multitenant Rails webapp for solving exercises, organized in terms of chapters and guides.

## Installing

### 1. Install essentials and base libraries

```bash
sudo apt-get install autoconf curl git build-essential libssl-dev autoconf bison libreadline6 libreadline6-dev zlib1g zlib1g-dev libsqlite3-dev sqlite3 postgresql libpq-dev rabbitmq-server  
```

### 2. Install rbenv

```bash
curl https://raw.githubusercontent.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc # or .bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bashrc # or .bash_profile
```

### 3. Install ruby

```bash
rbenv install 2.0.0-p481
rbenv global 2.0.0-p481
rbenv rehash
gem install bundler
```

### 4. Set development variables

```bash
echo "MUMUKI_AUTH0_CLIENT_ID=... \
      MUMUKI_AUTH0_CLIENT_SECRET=... \
      MUMUKI_AUTH0_DOMAIN=..." >> ~/.bashrc # or .bash_profile
```

### 5. Clone this repository

```bash
git clone https://github.com/mumuki/mumuki-atheneum
cd mumuki-atheneum
```

### 6. Install and setup database 

```bash
bundle install
bundle exec rake db:create db:schema:load db:seed
```

### Running 

```bash
rails s
```

### Deploying into production 

```bash
gem install escualo
escualo script atheneum.yml # see https://github.com/mumuki/escualo.rb
```

## Authentication Powered by Auth0 

<a width="150" height="50" href="https://auth0.com/" target="_blank" alt="Single Sign On & Token Based Authentication - Auth0"><img width="150" height="50" alt="JWT Auth for open source projects" src="http://cdn.auth0.com/oss/badges/a0-badge-dark.png"/></a>
