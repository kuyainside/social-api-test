# README

# Friends Management

[![N|Solid](https://www.shareicon.net/data/128x128/2015/11/23/676464_internet_512x512.png)](https://social-api-test.herokuapp.com)

[See API documentations](https://social-api-test.herokuapp.com)

# Features

  - Friend connections
  - Subscribe
  - Block / Ublock user from updates

# Unit Test Result
![N|Solid](https://preview.ibb.co/nayPdw/Screen_Shot_2017_10_09_at_4_11_43_PM.png)

> Some file are not coverage because I just ignore them as default.


### Tech

Dillinger uses a number of open source projects to work properly:

* [Ruby] - Dynamic, reflective, object-oriented, general-purpose programming language
* [Ruby on Rails] - A server-side web application framework written in Ruby
* [Rubygems] - The platform indicates the gem only works with a ruby built for the same platform
* [ApipieRails] - Ruby on Rails API documentation tool
* [Heroku] - A platform as a service (PaaS) that enables developers to build, run, and operate applications entirely in the cloud.

### Installation

How to [Install Rails](http://installrails.com/)

```sh
$ git clone REPOSITORY
$ cd project
$ bundle install
$ rake db:create && rake db:migrate
$ rails s
```

### Run Unit Testing

```sh
$ cd project
$ bundle exec rspec spec/
```

#### Expected
```
..............................

Finished in 3.68 seconds (files took 4.51 seconds to load)
30 examples, 0 failures

Coverage report generated for RSpec to /Users/achmadramdani/Documents/PROJECTS/social-api-test/coverage. 164 / 178 LOC (100%) covered.
```
