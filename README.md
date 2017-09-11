[![Build Status](https://travis-ci.org/mumuki/mumuki-laboratory.svg?branch=master)](https://travis-ci.org/mumuki/mumuki-laboratory)
[![Code Climate](https://codeclimate.com/github/mumuki/mumuki-laboratory/badges/gpa.svg)](https://codeclimate.com/github/mumuki/mumuki-laboratory)
[![Test Coverage](https://codeclimate.com/github/mumuki/mumuki-laboratory/badges/coverage.svg)](https://codeclimate.com/github/mumuki/mumuki-laboratory)
[![Issue Count](https://codeclimate.com/github/mumuki/mumuki-laboratory/badges/issue_count.svg)](https://codeclimate.com/github/mumuki/mumuki-laboratory)

<img width="60%" src="https://raw.githubusercontent.com/mumuki/mumuki-laboratory/master/laboratory-screenshot.png"></img>

# Mumuki Laboratory [![btn_donate_lg](https://cloud.githubusercontent.com/assets/1039278/16535119/386d7be2-3fbb-11e6-9ee5-ecde4cef142a.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=KCZ5AQR53CH26)
> Code assement web application for the Mumuki Platform

## About

Laboratory is a multitenant Rails webapp for solving exercises, organized in terms of chapters and guides.

## Preparing environment

### TL;DR install

1. Install [Vagrant](https://www.vagrantup.com/downloads.html) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Run `curl https://raw.githubusercontent.com/mumuki/mumuki-devinstaller/master/install.sh | bash`
3. `cd mumuki && vagrant ssh` and then - **inside Vagrant VM** - `cd /vagrant/laboratory`
4. Go to [Installing and Running](#installing-and-running)

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

### 4. Clone this repository

> Because, err... we need to clone this repostory before developing it :stuck_out_tongue:

```bash
git clone https://github.com/mumuki/mumuki-laboratory
cd mumuki-laboratory
```

### 5. Install and setup database

> We need to create a PostgreSQL role - AKA a user - who will be used by Laboratory to create and access the database

```bash
# create db user
sudo -u postgres psql <<EOF
  create role mumuki with createdb login password 'mumuki';
EOF

# create schema and initial development data
./devinit
```


## Installing and Running

### Quick start

If you want to start the server quickly in developer environment,
you can just do the following:

```bash
./devstart
```

This will install your dependencies and boot the server.

### Installing the server

If you just want to install dependencies, just do:

```
bundle install
```

### Running the server

You can boot the server by using the standard rackup command:

```
# using defaults from config/puma.rb and rackup default port 9292
bundle exec rackup

# changing port
bundle exec rackup -p 8080

# changing threads count
MUMUKI_LABORATORY_THREADS=30 bundle exec rackup

# changing workers count
MUMUKI_LABORATORY_WORKERS=4 bundle exec rackup
```

Or you can also start it with `puma` command, which gives you more control:

```
# using defaults from config/puma.rb
bundle exec puma

# changing ports, workers and threads count, using puma-specific options:
bundle exec puma -w 4 -t 2:30 -p 8080

# changing ports, workers and threads count, using environment variables:
MUMUKI_LABORATORY_WORKERS=4 MUMUKI_LABORATORY_PORT=8080 MUMUKI_LABORATORY_THREADS=30 bundle exec puma
```

Finally, you can also start your server using `rails`:

```bash
rails s
```

## Running tests

```bash
bundle exec rspec
```


## Authentication Powered by Auth0

<a width="150" height="50" href="https://auth0.com/" target="_blank" alt="Single Sign On & Token Based Authentication - Auth0"><img width="150" height="50" alt="JWT Auth for open source projects" src="http://cdn.auth0.com/oss/badges/a0-badge-dark.png"/></a>
