class CrawlerEngineMigrationGenerator < Rails::Generator::Base
	def manifest
		record do |m|
			options = {
				:migration_file_name => 'crawler_engine_migration'
			}
			m.migration_template 'migration.rb', 'db/migrate', options
		end
	end

	def banner
		"Usage: Generator crawler engine migration"
	end
end


