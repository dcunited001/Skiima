# encoding: utf-8
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/spec')
$LOAD_PATH.unshift(File.dirname(__FILE__))

gem "minitest"
require "minitest/spec"
require "minitest/autorun"
require "minitest/matchers"
require "minitest/pride"
require "mocha"
require "pry"

require "skiima"

SKIIMA_ROOT = File.dirname(__FILE__)

Skiima.setup do |config|
  config.root_path = SKIIMA_ROOT
  config.config_path = 'config'
  config.scripts_path = 'db/skiima'
  config.locale = :en
end

def ensure_closed(s, &block)
  yield s
ensure
  s.connection.close
end

def within_transaction(s, &block)
  s.connection.begin_db_transaction
  yield s
ensure
  s.connection.rollback_db_transaction
end