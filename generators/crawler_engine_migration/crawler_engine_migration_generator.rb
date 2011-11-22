class CrawlerEngineMigrationGenerator < Rails::Generator::Base
	def manifest
		record do |m|
			options = {
				:migration_file_name => 'create_crawler_engine'
			}
			m.migration_template 'migration.rb', 'db/migrate', options
		end
	end

	def banner
		"Usage: Generator crawler engine migration"
	end
end


