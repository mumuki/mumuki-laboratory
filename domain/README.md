Resource Hashes:

## Language

## Organization

## User

## Book

  name
  description
  locale
  slug
  chapters
  complements

## Topic

  name
  description
  locale
  slug
  lessons

## Guide

  guide
    exercises
      name
      bibliotheca_id
    authors
    collaborators
    description
    corollary
    name
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
    slug

## Exam

## Course

## Invitation


  Book.all.as_json(only: [:name, :slug])
