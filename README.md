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

### 1. Install essentials and base libraries

> First, we need to install some software: [PostgreSQL](https://www.postgresql.org) database, [RabbitMQ](https://www.rabbitmq.com/) queue, and some common Ruby on Rails native dependencies

```bash
sudo apt-get install autoconf curl git build-essential libssl-dev autoconf bison libreadline6 libreadline6-dev zlib1g zlib1g-dev postgresql libpq-dev rabbitmq-server
```

### 2. Install rbenv
> [rbenv](https://github.com/rbenv/rbenv) is a ruby versions manager, similar to rvm, nvm, and so on.

```bash
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc # or .bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bashrc # or .bash_profile
```

### 3. Install ruby

> Now we have rbenv installed, we can install ruby and [bundler](http://bundler.io/)

```bash
rbenv install 2.6.3
rbenv global 2.6.3
rbenv rehash
gem install bundler
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
# create db user for linux users
sudo -u postgres psql <<EOF
  create role mumuki with createdb login password 'mumuki';
EOF

# create db user for mac users
psql postgres
#once inside postgres server
create role mumuki with createdb login password 'mumuki';

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

## JavaScript API Docs

In order to be customized by runners, Laboratory exposes the following selectors and methods
which are granted to be safe and stable.

### Public Selectors

* `.mu-final-state`
* `.mu-initial-state-header`
* `.mu-initial-state`
* `.mu-kids-blocks`
* `.mu-kids-context`
* `.mu-kids-exercise-description`
* `.mu-kids-exercise`
* `.mu-kids-reset-button`
* `.mu-kids-results-aborted`
* `.mu-kids-results`
* `.mu-kids-state-image`
* `.mu-kids-state`
* `.mu-kids-states`
* `.mu-kids-submit-button`
* `.mu-multiple-scenarios`
* `.mu-scenarios`
* `#mu-actual-state-text`
* `#mu-custom-editor-default-value`
* `#mu-custom-editor-extra`
* `#mu-custom-editor-test`
* `#mu-custom-editor-value`
* `#mu-initial-state-text`

### Deprecated Selectors

* `.mu-kids-gbs-board-initial`: Use `.mu-initial-state` instead
* `.mu-state-final`: Use `.mu-final-state` instead
* `.mu-state-initial`: Use `.mu-initial-state` instead
* `#kids-context`: Use `.mu-kids-context` instead
* `#kids-results-aborted`: Use `.mu-kids-results-aborted` instead
* `#kids-results`: Use `.mu-kids-results` instead

### Methods

* `mumuki.bridge.Laboratory`
  * `.runTests`
* `mumuki.editor`
  * `formatContent`
  * `reset`
  * `toggleFullscreen`
* `mumuki.elipsis`
  * `replaceHtml`
* `mumuki.kids`
  * `registerBlocksAreaScaler`
  * `registerStateScaler`
  * `restart`
  * `scaleBlocksArea`
  * `scaleState`
  * `showResult`
* `mumuki.locale`
* `mumuki.MultipleScenarios`
  * `scenarios`
  * `currentScenarioIndex`
  * `resetIndicators`
  * `updateIndicators`
* `mumuki.multipleFileEditor`
  * `setUpAddFile`
  * `setUpDeleteFiles`
  * `setUpDeleteFile`
  * `updateButtonsVisibility`
* `mumuki.version`

### Bridge Response Format

```json
{
  "status": "failed",
  "guide_finished_by_solution": false,
  "class_for_progress_list_item":"progress-list-item text-center danger active",
  "html":"...",
  "title_html":"...",
  "button_html":"...",
  "expectations_html":"...",
  "remaining_attempts_html":null,
  "test_results":[
      {
        "title":null,
        "status":"failed",
        "result":"..."
      }
  ]
}
```

### Kids Call order

0. Laboratory Kids API Initialization
1. Runner Editor JS
2. Laboratory Kids Layout Initialization
3. Runner Editor HTML

## Transparent Navigation API Docs

In order to be able to link content, laboratory exposes slug-based routes that will redirect to the actual
content URL in the current organization transparently:

* `GET <organization-url>/topics/<organization>/<repository>`
* `GET <organization-url>/guides/<organization>/<repository>`
* `GET <organization-url>/exercises/<organization>/<repository>/<bibliotheca-id>`

## REST API Docs

Before using the API, you must create an `ApiClient` using `rails c`, which will generate a private JWT. Use it to authenticate API calls in any Platform application within a `Authorizaion: Bearer <TOKEN>`.

Before using the API, take a look to the roles hierarchy:

![roles hierarchy](https://yuml.me/diagram/plain/class/[Admin]%5E-[Janitor],[Admin]%5E-[Moderator],%20[Janitor]%5E-[Headmaster],%20[Headmaster]%5E-[Teacher],%20[Teacher]%5E-[Student],%20,%20[Admin]%5E-[Editor],%20[Editor]%5E-[Writer],%20[Owner]%5E-[Admin]).

Permissions are bound to a scope, that states in which context the operation can be performed. Scopes are simply two-level contexts, expressed as slugss `<first>/<second>`, without any explicit semantic. They exact meaning depends on the role:

  * student: `organization/course`
  * teacher and headmaster: `organization/course`
  * writer and editor: `organization/content`
  * janitor: `organization/_`
  * moderator: `organization/_`
  * admin: `_/_`
  * owner: `_/_`

### Users

#### Create single user

This is a generic user creation request.

**Minimal permission**: `janitor`

```
POST /users
```

Sample request body:

```json
{
  "first_name": "María",
  "last_name": "Casas",
  "email": "maryK345@foobar.edu.ar",
  "permissions": {
     "student": "cpt/*:rte/*",
     "teacher": "ppp/2016-2q"
  }
}
```

#### Update single user

This is a way of updating user basic data. Permissions are ignored.

**Minimal permission**: `janitor`

```
PUT /users/:uid
```

Sample request body:

```json
{
  "first_name": "María",
  "last_name": "Casas",
  "email": "maryK345@foobar.edu.ar",
  "uid": "maryK345@foobar.edu.ar"
}
```

#### Add student to course

Creates the student if necessary, and updates her permissions.

**Minimal permission**: `janitor`

```
POST /courses/:organization/:course/students
```

```json
{
  "first_name": "María",
  "last_name": "Casas",
  "email": "maryK345@foobar.edu.ar",
  "uid": "maryK345@foobar.edu.ar"
}
```
**Response**
```json
{
  "uid": "maryK345@foobar.edu.ar",
  "first_name": "María",
  "last_name": "Casas",
  "email": "maryK345@foobar.edu.ar"
}
```
**Forbidden Response**
```json
{
  "status": 403,
  "error": "Exception"
}
```

#### Detach student from course

Remove student permissions from a course.

**Minimal permission**: `janitor`

```
POST /courses/:organization/:course/students/:uid/detach
```

**Response**: status code: 200


**Not Found Response**
```json
{
  "status": 404,
  "error": "Couldn't find User"
}
```

#### Attach student to course

Add student permissions to a course.

**Minimal permission**: `janitor`

```
POST /courses/:organization/:course/students/:uid/attach
```
**Response**: status code: 200

**Not Found Response**
```json
{
  "status": 404,
  "error": "Couldn't find User"
}
```


#### Add teacher to course

Creates the teacher if necessary, and updates her permissions.

**Minimal permission**: `headmaster`, `janitor`

```
POST /course/:id/teachers
```

```json
{
  "first_name": "Erica",
  "last_name": "Gonzalez",
  "email": "egonzalez@foobar.edu.ar",
  "uid": "egonzalez@foobar.edu.ar"
}
```

#### Add a batch of users to a course

Creates every user if necesssary, an updates permissions.

**Minimal permission**: `janitor`

```
POST /course/:id/batches
```

```json
{
  "students": [
    {
      "first_name": "Tupac",
      "last_name": "Lincoln",
      "email": "tliconln@foobar.edu.ar",
      "uid": "tliconln@foobar.edu.ar"
    }
  ],
  "teachers": [
    {
      "first_name": "Erica",
      "last_name": "Gonzalez",
      "email": "egonzalez@foobar.edu.ar",
      "uid": "egonzalez@foobar.edu.ar"
    }
  ]
}
```

#### Detach student from course

**Minimal permission**: `janitor`

```
DELETE /course/:id/students/:uid
```

#### Detach teacher from course

**Minimal permission**: `janitor`

```
DELETE /course/:id/teachers/:uid
```

#### Destroy single user

**Minimal permission**: `admin`

```
DELETE /users/:uid
```

### Courses

#### Create single course

**Minimal permission**: `janitor`

```
POST /organization/:id/courses/
```

```json
{
   "name":"....",
}
```

#### Archive single course

**Minimal permission**: `janitor`

```
DELETE /organization/:id/courses/:id
```

#### Destroy single course

**Minimal permission**: `admin`

```
DELETE /courses/:id
```


### Organizations

#### Model

### Mandatory fields
```json
{
  "name": "academy",
  "contact_email": "issues@mumuki.io",
  "books": [
    "MumukiProject/mumuki-libro-metaprogramacion"
  ],
  "locale": "es-AR"
}
```

### Optional fields
```json
{
  "public": false,
  "description": "...",
  "login_methods": [
    "facebook", "twitter", "google"
  ],
  "logo_url": "http://mumuki.io/logo-alt-large.png",
  "terms_of_service": "Al usar Mumuki aceptás que las soluciones de tus ejercicios sean registradas para ser corregidas por tu/s docente/s...",
  "theme_stylesheet": ".theme { color: red }",
  "extension_javascript": "doSomething = function() { }"
}
```

- If you set `null` to `public`, `login_methods`, the values will be `false` and `["user_pass"].
- If you set `null` to `description`, the value will be `null`.
- If you set `null` to the others, it will be inherited from an organization called `"base"` every time you query the API.


### Generated fields
```json
{
  "theme_stylesheet_url": "stylesheets/academy-asjdf92j1jd8.css",
  "extension_javascript_url": "javascripts/academy-jd912j8jdj19.js"
}
```

#### List all organizations

```
get /organizations
```

Sample response body:

```json
{
  "organizations": [
    { "name": "academy", "contact_email": "a@a.com", "locale": "es-AR", "login_methods": ["facebook"], "books": ["libro"], "public": true, "logo_url":"http://..." },
    { "name": "alcal", "contact_email": "b@b.com", "locale": "en-US", "login_methods": ["facebook", "github"], "books": ["book"], "public": false }
  ]
}
```
**Minimal permission**: None for public organizations, `janitor` for user's private organizations.

#### Get single organization by name

```
get /organizations/:name
```

Sample response body:

```json
{ "name": "academy", "contact_email": "a@a.com", "locale": "es-AR", "login_methods": ["facebook"], "books": ["libro"], "public": true, "logo_url":"http://..." }
```
**Minimal permission**: `janitor` of the organization.

#### Create organization

```
post /organizations
```
... with at least the required fields.

**Minimal permission**: `admin` of that organization

#### Update organization

```
put /organizations/:name
```
... with a partial update.

**Minimal permission**: `admin` of `:name`


## Authentication Powered by Auth0

<a width="150" height="50" href="https://auth0.com/" target="_blank" alt="Single Sign On & Token Based Authentication - Auth0"><img width="150" height="50" alt="JWT Auth for open source projects" src="http://cdn.auth0.com/oss/badges/a0-badge-dark.png"/></a>
