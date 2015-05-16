[![Stories in Ready](https://badge.waffle.io/uqbar-project/mumuki-platform.png?label=ready&title=Ready)](https://waffle.io/uqbar-project/mumuki-platform)
[![Build Status](https://travis-ci.org/uqbar-project/mumuki-platform.svg?branch=master)](https://travis-ci.org/uqbar-project/mumuki-platform)
[![Code Climate](https://codeclimate.com/github/uqbar-project/mumuki-platform/badges/gpa.svg)](https://codeclimate.com/github/uqbar-project/mumuki-platform)
[![Test Coverage](https://codeclimate.com/github/uqbar-project/mumuki-platform/badges/coverage.svg)](https://codeclimate.com/github/uqbar-project/mumuki-platform)

Mumuki
======

Open platform for distribution and validation of programming exercises

# What is Mumuki?

Mumuki is just a simple, open and collaborative platform that allows users to store and distribute programming exercises - that is a problem description and a set of automated tests -, and submit their solutions. It is aimed at assisting people in learning programming languages and paradigms.

## Mumuki is simple

We say Mumuki is a simple platform, because it just provides exercise distribution and validation - you will not get any grading or certificates for sending correct submissions. It just allows you to practice your programming skills, in the form of programming quizzes.

Think of it as a [Code Kata](http://codekata.com/) platform, where you can get feedback of your solution. 

## Mumuki content is collaborative

In Mumuki, exercises are not provided by experts but by the community. There is no distinction between a teacher and a student in Mumuki - anyone can create new exercises. We encourage you to submit your own programming problems.

## Mumuki is an open platform 

We would like you to collaborate on Mumuki development - we are waiting for your pull request. But if you just want to fork it, go on, it is just open source software. 

Mumuki is also open for extension, we would like to have exercises for a large range of programming languages

# Which languages are supported?

Currently Mumuki supports Haskell, through [GHC](https://www.haskell.org/ghc/), Prolog,
through [SWI-Prolog](http://www.swi-prolog.org/), Ruby and JavaScript. Support for more programming languages is a pending task. We would like to offer support in the short term for the following too: 
 * Clojure
 * Smalltalk
 
# How can I contribute?

1. Navigate Mumuki at http://mumuki.io, and submit issues for every thing you dislike
1. Check the current issues, fork the repository, and take any of your interest. Then pull request it.
1. Choose your preffered language and create your test runner server. Use any of those server for inspiration:
  * [mumuki-hspec-server](https://github.com/uqbar-project/mumuki-hspec-server) (written in Haskell)
  * [mumuki-rspec-server](https://github.com/aguspina/mumuki-rspec-server)  (written in Ruby)
  * [mumuki-mocha-server](https://github.com/aguspina/mumuki-mocha-server)  (written in JavaScript)
  * [mumuki-plunit-server](https://github.com/uqbar-project/mumuki-plunit-server)  (written in Ruby)
  * [mumuki-gobstones-server](https://github.com/uqbar-project/mumuki-gobstones-server)  (written in Ruby)
  * Experimental: [mumuki-cspec-server](https://github.com/mgarciaisaia/mumuki-cspec-server)  (written in Ruby)
 
1. Create exercises! Mumuki is in early stages, so remember to add your tests to some SCM. 
1. Are you a UI designer? We want Mumuki to look great. 

# Please Support Uqbar Project too!

Mumuki was born as an [Uqbar Project](http://www.uqbar-project.org/). Please support Uqbar too!

# Where can I read more?

Check the wiki!
