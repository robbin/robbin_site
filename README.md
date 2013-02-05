# Robbin's website  

<http://robbinfan.com>

This is my personal website project.

## Installing
1. run `bundle install`
2. copy `config/app_config.example.yml` to `config/app_config.yml` and copy `config/database.example.yml` to `config/database.yml`
3. modify database config for your need.
4. run `rake secret` to generate session secret key and fill it in app_config.
5. create database match your database.yml and start your database.
6. run `rake ar:migrate` to setup database schema.
7. run `rake seed` to generate admin user.
8. start memcached with `memcached -d`.
9. run `thin start` for development environment and run `unicorn -c config/unicorn.rb -E production -D` for production environment.

## MIT License