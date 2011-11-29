#encoding:utf-8
require 'rubygems'
require 'active_record'

dbconfig = YAML::load(File.open(File.dirname(__FILE__)+'/database.yml'))
ActiveRecord::Base.establish_connection(dbconfig)
