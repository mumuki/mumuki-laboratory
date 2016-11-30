[![Stories in Ready](https://badge.waffle.io/mumuki/mumuki-atheneum.png?label=ready&title=Ready)](https://waffle.io/mumuki/mumuki-atheneum)
[![Build Status](https://travis-ci.org/mumuki/mumuki-atheneum.svg?branch=master)](https://travis-ci.org/mumuki/mumuki-atheneum)
[![Code Climate](https://codeclimate.com/github/mumuki/mumuki-atheneum/badges/gpa.svg)](https://codeclimate.com/github/mumuki/mumuki-atheneum)
[![Test Coverage](https://codeclimate.com/github/mumuki/mumuki-atheneum/badges/coverage.svg)](https://codeclimate.com/github/mumuki/mumuki-atheneum)
[![Issue Count](https://codeclimate.com/github/mumuki/mumuki-atheneum/badges/issue_count.svg)](https://codeclimate.com/github/mumuki/mumuki-atheneum)


Mumuki Atheneum [![btn_donate_lg](https://cloud.githubusercontent.com/assets/1039278/16535119/386d7be2-3fbb-11e6-9ee5-ecde4cef142a.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=KCZ5AQR53CH26)
================

> Code assement web application for the Mumuki Platform

## About
Atheneum is a multitenant Rails webapp for solving exercises, organized in terms of chapters and guides.

## Installing

For development, you've to add to your `/etc/hosts` file:
```
127.0.0.1 localmumuki.io
127.0.0.1 central.localmumuki.io
127.0.0.1 central.classroom.localmumuki.io
```

### TL;DR install

1. Install [Vagrant](https://www.vagrantup.com/downloads.html) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Run `curl https://raw.githubusercontent.com/mumuki/mumuki-development-installer/master/install.sh | bash`
3. `cd mumuki && vagrant ssh` and then - **inside Vagrant VM** - `cd /vagrant/atheneum`
4. Go to step 7

### 1. Install essentials and base libraries

> First, we need to install some software: [PostgreSQL](https://www.postgresql.org) database, [RabbitMQ](https://www.rabbitmq.com/) queue, and some common Ruby on Rails native dependencies

```bash
sudo apt-get install autoconf curl git build-essential libssl-dev autoconf bison libreadline6 libreadline6-dev zlib1g zlib1g-dev postgresql libpq-dev rabbitmq-server
```

### 2. Install rbenv
> [rbenv](https://github.com/rbenv/rbenv) is a ruby versions manager, similar to rvm, nvm, and so on.

```bash
curl https://raw.githubusercontent.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc # or .bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bashrc # or .bash_profile
```

### 3. Install ruby

> Now we have rbenv installed, we can install ruby and [bundler](http://bundler.io/)

```bash
rbenv install 2.3.1
rbenv global 2.3.1
rbenv rehash
gem install bundler
gem install escualo
```

### 4. Set development variables

```bash
echo "MUMUKI_AUTH0_CLIENT_ID=... \
      MUMUKI_AUTH0_CLIENT_SECRET=... \
      MUMUKI_AUTH0_DOMAIN=..." >> ~/.bashrc # or .bash_profile
```

### 5. Create database user

> We need to create a PostgreSQL role - AKA a user - who will be used by Atheneum to create and access the database

```bash
sudo -u postgres psql <<EOF
  create role mumuki with createdb login password 'mumuki';
EOF
```

### 6. Clone this repository

> Because, err... we need to clone this repostory before developing it :stuck_out_tongue:

```bash
git clone https://github.com/mumuki/mumuki-atheneum
cd mumuki-atheneum
```

### 7. Install and setup database

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
