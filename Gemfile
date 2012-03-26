# encoding: utf-8
source "http://rubygems.org"

# Specify your gem's dependencies in skiima.gemspec
gemspec

group :development do
  gem 'guard'
  gem 'guard-minitest'
  gem 'pry'
  gem 'rake'

  gem 'pg'
  gem 'mysql'
  gem 'mysql2'
end

if Config::CONFIG['target_os'] =~ /darwin/i
  gem 'rb-fsevent', '>= 0.3.2'
  gem 'growl',      '~> 1.0.3'
end
if Config::CONFIG['target_os'] =~ /linux/i
  gem 'rb-inotify', '>= 0.5.1'
  gem 'libnotify',  '~> 0.1.3'
end
if RbConfig::CONFIG['target_os'] =~ /mswin|mingw/i
  gem 'win32console',             :require => false
  gem 'rb-fchange',   '~> 0.0.2', :require => false
  gem 'rb-notifu',    '~> 0.0.4', :require => false
end
