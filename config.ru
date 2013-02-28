#!/usr/bin/env rackup
# encoding: utf-8

# This file can be used to start Padrino,
# just execute it from the command line.

require File.expand_path("../config/boot.rb", __FILE__)

# use ruby standard logger because padrino logger has odd error in my production environment.
require 'logger'
class ::Logger; alias_method :write, :<<; end

if ENV['RACK_ENV'] == 'production'
  logger = ::Logger.new("log/production.log")
  logger.level = ::Logger::WARN
  use Rack::CommonLogger, logger
end

run Padrino.application
