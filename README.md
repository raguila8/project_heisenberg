# Project Heisenberg

Inspired by Project Euler, Project Heisenberg (named after theoretical physicist Werner Karl Heisenberg) is a website dedicated to a series of challenging physics problems. The project is a platform for the curious mind to delve into the world of physics and learn mathematical and physical concepts in a fun and recrational way. The problems are aimed at students who want to learn beyond their basic curriculum, anyone seeking to understand the essential nature of the world and proffessionals who want to keep their problem solving, physics and mathematics sharp.

Project Heisenberg allows users to track their progress through achievement levels based on problems solved and their difficulty level. In addition, users are able to track their friends' progress and discuss problems with them.

Each problem has its own discussion thread that is only available to those who have solved the problem already. Once you have access you will be able to see how other members have solved the problem, discuss methods, and share your insights.

[View Project](https://mighty-wave-85570.herokuapp.com/) 

* Ruby version - 2.3.3

* Rails version - 5.1.4

## Running Locally

* Configuration - run `bundle install` to install and include the gems specified in the `Gemfile`, while skipping the installation gems using the option `--without production`:

```linux
$ bundle install --without production
```

This arranges to skip the pg gem for PostgreSQL in development and use SQLite for development and testing. In case you've previously installed a version of a gem (such as Rails) other than the one specified by the Gemfile, it's a good idea to update the fems with `bundle install` to make sure the versions match:

```linux
$ bundle update
```
### Database

There are a total of 10 tables that store all the data. To seed the database I use the standard ruby file `db/seeds.rb` along with the `Faker` gem to make sample users, posts and problems.

```linux
$ rails db:seed
```

## TODO

* Make site responsive
* Allow users to report posts
* Make a `recent` page where users can see recent friend activity as well as site wide anouncements
* Make a statistics page that shows the combined stats of all users
* Posts should support markup for Math symbols and notation
