#encoding:utf-8
require File.expand_path('../db_adaptor',__FILE__)

class Post < ActiveRecord::Base
	  set_table_name "posts"
end
