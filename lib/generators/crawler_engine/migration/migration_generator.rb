require 'rails/generators'
require 'rails/generators/migration'

class CrawlerEngineGenerator < Rails::Generator::Base
	include Rails::Generators::Migration

	desc "Generates migration for crawler engine model"
	def self.source_root
		#File.join(File.dirname(__FILE__), 'templates')
		File.expand_path('../templates', __FILE__)
	end

	def create_migration_file
		migration_template 'migration.rb', 'db/migrate/crawler_engine_migration'
	end
end


