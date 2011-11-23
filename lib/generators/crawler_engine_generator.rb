require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record'

class CrawlerEngineGenerator < Rails::Generators::Base
	include Rails::Generators::Migration
	extend ActiveRecord::Generators::Migration

	desc "Generates migration for crawler engine model"
	def self.source_root
		File.expand_path('../templates', __FILE__)
	end

	def create_migration_file
		migration_template 'migration.rb', 'db/migrate/create_crawler_engine'
	end

	def crate_model_file
		template 'post.rb', 'app/models/post.rb'
		template 'source.rb', 'app/models/source.rb'
	end
end


