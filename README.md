# Robbin's website  

<http://robbinfan.com>

This is my personal website project.

## System requirements

* ruby 1.9, recommend 1.9 p327 version
* MySQL 5.x, you should set utf-8 default encoding utf-8 at `my.cnf`, like this:

        [client]   # on 5.0 or 5.1
        default-character-set=utf8
        [mysqld]
        default-character-set=utf8 

        [mysqld]   # on 5.5
        collation-server = utf8_unicode_ci
        init-connect='SET NAMES utf8'
        character-set-server = utf8

* memcached
* nginx as web server, `config/nginx.conf` is my nginx configuration snippet.

## Install
1. run `bundle install`
2. copy `config/app_config.example.yml` to `config/app_config.yml` and copy `config/database.example.yml` to `config/database.yml`
3. modify database config for your need.
4. create database match your database.yml and start your database.
5. run `bundle exec rake secret` to generate session secret key and fill it in app_config.
6. run `bundle exec rake ar:migrate` to setup database schema.
7. run `bundle exec rake db:seed` to generate admin user.
8. start memcached with `memcached -d`.
9. run `bundle exec thin start` for development environment and run `./zbatery.sh start` for production environment.

## Run on Windows

remove such lines in `Gemfile` and run with thin.

    gem 'kgio'
    gem 'zbatery'

## MIT License