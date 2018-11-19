# Resource Hashes

## Runner Hashes

### `Language`

```
  name
  comment_type
  runner_url
  output_content_type
  prompt
  extension
  highlight_mode
  visible_success_output
  devicon
  triable
  feedback
  queriable
  stateful_console
  test_extension
  test_template
  layout_js_urls
  layout_html_urls
  layout_css_urls
  editor_js_urls
  editor_html_urls
  editor_css_urls
```

_as defined in `Language#to_resource_h`_

## Platform Hashes

### `Organization`

```
  name
  book
  profile
  settings
  theme
```

_as defined in `Mumukit::Platform::Organization::Helpers#to_resource_h`_

### `User`

```
  uid
  social_id
  image_url
  email
  first_name
  last_name
  permissions
```

_as defined in `Mumukit::Platform::User::Helpers#to_resource_h`_

### `Course`

```
  slug
  shifts
  code
  days
  period
  description
```

_as defined in `Mumukit::Platform::Course::Helpers#to_resource_h`_

## Content Hashes

### `Book`

```
  name
  description
  locale
  slug
  chapters
  complements
```

_as defined in `Book#to_resource_h`_


### `Topic`

```
  name
  description
  locale
  slug
  lessons
```

_as defined in `Topic#to_resource_h`_

### `Guide`

```
  slug
  name
  exercises
    name
    bibliotheca_id
    layout
    editor
    description
    corollary
    teacher_info
    hint
    locale
    choices
    expectations
    assistance_rules,
    randomizations
    tag_list
    extra_visible
    test
    manual_evaluation
    language
      name
      extension
      test_extension
  authors
  private
  expectations
  collaborators
  description
  corollary
  locale
  type
  beta
  teacher_info
  language
    name
    extension
    test_extension
  id_format
  extra
```

_as defined in `Guide#to_resource_h`_

## Classroom Hashes

* `Exam`
* `Invitation`
