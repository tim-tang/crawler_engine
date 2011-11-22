#encoding:utf-8
require 'rubygems'
require 'active_record'
require 'logger'
dbconfig = YAML::load(File.open(File.dirname(__FILE__)+'/database.yml'))
ActiveRecord::Base.logger = Logger.new('/tmp/crawler_engine.log')
ActiveRecord::Base.establish_connection(dbconfig)
