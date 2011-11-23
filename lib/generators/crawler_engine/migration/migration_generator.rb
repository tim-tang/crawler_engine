require 'rails/generators'
require 'rails/generators/migration'

class CrawlerEngineGenerator < Rails::Generator::Base
	include Rails::Generators::Migration

	desc "Generates migration for Tag and Tagging models"
	def self.source_root
		File.join(File.dirname(__FILE__), 'templates')
	end

	def create_migration_file
		migration_template 'migration.rb', 'db/migrate/crawler_engine_migration'
	end
end


