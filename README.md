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

## Running JS tests

> You need first to download [geckodriver](https://github.com/mozilla/geckodriver/releases/download/v0.27.0/geckodriver-v0.27.0-linux64.tar.gz), uncrompress
> it and add it to your path

```bash
MOZ_HEADLESS=1 bundle exec rake teaspoon
```

## Running `eslint`

```bash
yarn run lint
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
* `.mu-submit-button`
* `#mu-actual-state-text`
* `#mu-${languageName}-custom-editor`
* `#mu-custom-editor-default-value`
* `#mu-custom-editor-extra`
* `#mu-custom-editor-test`
* `#mu-custom-editor-value`
* `#mu-initial-state-text`

### Deprecated Selectors

* `.mu-kids-gbs-board-initial`: Use `.mu-initial-state` instead
* `.mu-state-final`: Use `.mu-final-state` instead
* `.mu-state-initial`: Use `.mu-initial-state` instead
* `#kids-results-aborted`: Use `.mu-kids-results-aborted` instead
* `#kids-results`: Use `.mu-kids-results` instead

### Methods

* `mumuki.bridge.Laboratory`
  * `.runTests`
* `mumuki.CustomEditor`
  * `addSource`
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
  * `showContext`
* `mumuki.renderers`
  * `SpeechBubbleRenderer`
  * `renderSpeechBubbleResultItem`
* `mumuki.locale`
* `mumuki.exercise`
   * `id`: the `id` of the currently loaded exercise, if any
   * `layout`: the `layout` of the currently loaded exercise, if any
* `mumuki.incognitoUser`: whether the current user is an incognito user
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
* `mumuki.submission`
  * `processSolution`
  * `registerContentSyncer`
* `mumuki.version`

### Bridge Response Format

```javascript
{
  "status": "passed|passed_with_warnings|failed",
  "guide_finished_by_solution": "boolean",
  "html": "string",
  "remaining_attempts_html": "string" ,
  "title_html": "string",                         // kids-only
  "button_html": "string",                        // kids-only
  "expectations": [                               // kids-only
    {
      "status": "passed|failed",
      "explanation": "string"
    }
  ],
  "tips": [ "string" ],                           // kids-only
  "test_results": [                               // kids-only
    {
      "title": "string",
      "status": "passed|failed",
      "result": "string",
      "summary": "string"
    }
  ]
}
```

### Kids Call order

0. Laboratory Kids API Initialization
1. Runner Editor JS
2. Laboratory Kids Layout Initialization
3. Runner Editor HTML

## Generic event system

Laboartory provides the `mumuki.events` object, which acts as minimal, generic event system, which is mostly designed for third party components built on top of laboratory and runners. It does nothing by default.

This API has two parts: consumers API and producers API.

```javascript
// ======
// producer
// ======

// you need to call this method in order to enable registration of event handlers
// otherwise, it will  be ignored
mumuki.events.enable('myEvent');

// fire the event, with an optional event object as payload
mumuki.events.fire('myEvent', aPlainOldObject);

// clear all the registered event handlers
mumuki.events.clear('myEvent');

// ========
// consumer
// ========

// register an event handler
mumuki.events.on('myEvent', (anEventObject) => {
  // do stuff
});
```


## Custom editors

Mumuki provides several editor types: code editors, multiple choice, file upload, and so on.
However, some runners will require custom editors in order to provide better ways of entering
solutions.

The process to do so is not difficult, but tricky, since there are a few hooks you need to implement. Let's look at them:

### 1. Before state: adding layout assets

If you need to provide a custom editor, chances are that you also need to provide assets to augment the layout, e.g. providing ways
to render some custom components on descriptions or corollaries. That code will be included first.

In order to do that, add to your runner the layout html, css and js code. Layout code has no further requirements. It can customize any public selector previously.

Although it is not required, it is recommended that your layout code works with any of the mumuki layouts:

* `input_right`
* `input_bottom`
* `input_primary`
* `input_kindergarten`

:warning: Not all the selectors will be available to all layouts.

Then expose code in the `MetadataHook`:

```ruby
class ... < Mumukit::Hook
  def metadata
    {
      layout_assets_urls: {
        js: [
          'assets/....'
        ],
        css: [
          'assets/....'
        ],
        html: [
          'assets/....'
        ]
      }
    }
  end
end
```

Finally, it is _recommended_ that you layout code calls `mumuki.assetsLoadedFor('layout')` when fully loaded.

That's it!

### 2. Adding custom editor assets

The process for registering custom editors is more involving.

#### 2.1 Add your assets and expose them

Add your js, css and html assets to your runner, and expose them in `MetadataHook`:

```ruby
class ... < Mumukit::Hook
  def metadata
    {
      editor_assets_urls: {
        js: [
          'assets/....'
        ],
        css: [
          'assets/....'
        ],
        html: [
          'assets/....'
        ]
      }
    }
  end
end
```

These assets will only be loaded when the editor `custom` is used.

#### 2.2 Add your components to the custom editor

Using JavaScript, append your components the custom-editor root, which can be found using the following selectors:

* `mu-${languageName}-custom-editor`
* `#mu-${languageName}-custom-editor`
* `.mu-${languageName}-custom-editor`

```javascript
$('#mu-mylang-custom-editor').append(/* ... */)
```

#### 2.3 Extract the test

If necessary, read the test definition from `#mu-custom-editor-test`, and plump into your custom components

```javascript
const test = $('#mu-custom-editor-test').val()
//...use test...
```

#### 2.4 Exposing your content

Before sending a submission, mumuki needs to be able to your read you editor components
contents. There are two different approaches:

* Register a syncer that writes `#mu-custom-editor-value` or any other custom editor selectors
* Add one or more content sources

```javascript
// simplest method - you can register just one
mumuki.editors.registerContentSyncer(() => {
  // ... write here your custom component content...
  $('#mu-custom-editor-value').val(/* ... */);
});

// alternate method
// you can register many sources
mumuki.editors.addCustomSource({
  getContent() {
    return { name: "solution[content]", value: /* ... */ } ;
  }
});
```

#### 2.5 Optional: Sending your solution to the server programmatically

Your solution will be automatically sent to the client when the submit button is pressed. However,
if you need to trigger submission process programmatically, call `mumuki.submission.processSolution`:

```javascript
mumuki.submission.processSolution({solution: {content: /* ... */}});
```

#### 2.6 Optional: customizing your submit button

You can alternatively override the default submit button UI and behaviour, by replacing it with a custom component. In order to
do that, override the `.mu-submit-button` or the kids-specific `.mu-kids-submit-button`:

```javascript
 $(".mu-submit-button").html(/* ... */);
```

However, doing this is tricky, since you will need to manually update the UI and connecting to the server. See:

* `mumuki.kids.showResult`
* `mumuki.bridge.Laboratory.runTests`
* `mumuki.updateProgressBarAndShowModal`

#### 2.7 Register kids scalers

Kids layouts have some special areas:

 * _state area_: its display initial and/or final states of the exercise
 * _blocks area_: a workspace that contains the building blocks of the solution - which are not necessary programming or blockly blocks, actually

If you want to support kids layouts, you **need** to register scalers that will be called when device is resized. Skip this step otherwise.

```javascript
mumuki.kids.registerStateScaler(($state, fullMargin, preferredWidth, preferredHeight) => {
  // ... resize your components ...
});

mumuki.kids.registerBlocksAreaScaler(($blocks) => {
  // ... resize your components ...
});
```

#### 2.8 Notify when your assets have been loaded

In order to remove loading spinners, you will need to call `mumuki.assetsLoadedFor` when your code is ready.

```javascript
mumuki.assetsLoadedFor('editor');
```

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
   "name": "....",
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
    { "name": "academy", "contact_email": "a@a.com", "locale": "es-AR", "login_methods": ["facebook"], "books": ["libro"], "public": true, "logo_url": "http://..." },
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
{ "name": "academy", "contact_email": "a@a.com", "locale": "es-AR", "login_methods": ["facebook"], "books": ["libro"], "public": true, "logo_url": "http://..." }
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
