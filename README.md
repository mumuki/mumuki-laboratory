[![Stories in Ready](https://badge.waffle.io/mumuki/mumuki-platform.png?label=ready&title=Ready)](https://waffle.io/mumuki/mumuki-platform)
[![Build Status](https://travis-ci.org/mumuki/mumuki-platform.svg?branch=master)](https://travis-ci.org/mumuki/mumuki-platform)
[![Code Climate](https://codeclimate.com/github/mumuki/mumuki-platform/badges/gpa.svg)](https://codeclimate.com/github/mumuki/mumuki-platform)
[![Test Coverage](https://codeclimate.com/github/mumuki/mumuki-platform/badges/coverage.svg)](https://codeclimate.com/github/mumuki/mumuki-platform)

Mumuki Platform
================

Open Source CMS Platform for sharing and solving programming problems. It is the hearth of the [Mumuki Project](http://mumuki.org)

# What is Mumuki Platform?

Mumuki is just a simple, open and collaborative platform that allows users to store and distribute programming exercises - that is a problem description and a set of automated tests -, and submit their solutions. It is aimed at assisting people in learning programming languages and paradigms.

## Mumuki Platform is simple

We say Mumuki is a simple platform, because it just provides exercise distribution and validation - you will not get any grading or certificates for sending correct submissions. It just allows you to practice your programming skills, in the form of programming quizzes.

Think of it as a [Code Kata](http://codekata.com/) platform, where you can get feedback of your solution. 

This simplicity brings its flexibility: we use it in Mumuki Project for teaching and practicing abut programming online, but you could find other use cases for it:

* Interactive Exams
* Programming Competitions support
* Even you could use to in other felds, not related to programming! Math or chess exercises, for instance.  

## Mumuki Platform's content is collaborative

In Mumuki, exercises are not provided by experts but by the community. There is no distinction between a teacher and a student in Mumuki - anyone can create new exercises. 


## Mumuki Platform is open 

We would like you to collaborate on Mumuki Platform development - we are waiting for your pull request. But if you just want to fork it, go on, it is just open source software. 

Mumuki is also open for extension, we would like to have exercises for a large range of programming languages. The way of extending Mumuki is using plugins called `runners`. You can find several runners in [Our organization](https://github.com/mumuki)


# Some FAQs

## Which languages are supported?

Thanks our pluggable runners system, Mumuki Platform supports Haskell, through [GHC](https://www.haskell.org/ghc/), Prolog,
through [SWI-Prolog](http://www.swi-prolog.org/), Ruby and JavaScript. 

We have recently added support for [Gobstones](http://www.gobstones.org/), too!

We would like to add support for Clojure, Mongo queries and SQL in the short term. Would you like to help us?


## How can I contribute?

1. Navigate Mumuki at http://mumuki.io, and submit issues for every thing you dislike
1. Check the current issues, fork the repository, and take any of your interest. Then pull request it.
1. Choose your preffered language and create your test runner server, or help with existing runners development. Use any of these for inspiration:
  * [mumuki-hspec-server](https://github.com/mumuki/mumuki-hspec-server) (written in Haskell)
  * [mumuki-rspec-server](https://github.com/mumuki/mumuki-rspec-server)  (written in Ruby)
  * [mumuki-mocha-server](https://github.com/mumuki/mumuki-mocha-server)  (written in JavaScript)
  * [mumuki-plunit-server](https://github.com/mumuki/mumuki-plunit-server)  (written in Ruby)
  * [mumuki-gobstones-server](https://github.com/uqbar-project/mumuki-gobstones-server)  (written in Ruby)
  * Experimental: [mumuki-cspec-server](https://github.com/mgarciaisaia/mumuki-cspec-server)  (written in Ruby)
 
1. Create exercises! 
1. Create a guide! A guide is a set of exercises
1. Are you a UI designer? We want Mumuki to look great. 
1. And spread the word. We belive that knowledge is not complete free if tools and content aren't. That is why Mumuki Platform and Mumuki Project are here.  

## Who sponors this platform?

* The [Mumuki Project](http://mumuki.org)
* The [Uqbar Project](http://www.uqbar-project.org/). Please support Uqbar too!
* You!

## Where can I read more?

Check:

 * The wiki
 * Spanish resources:
    * https://www.facebook.com/mumukiapp
    * https://twitter.com/MumukiProject
    * The Mumuki Project page
    * Our mailing List
