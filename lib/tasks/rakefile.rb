require File.expand_path('../../source',__FILE__)
desc "Initial crawler engine database"
task :crawler_setup do
	#puts Source.count
#	if File.exists?(Dir.pwd + "/seeds.rb")
#		if Rake.application.lookup('db:seed')
#			Rake::Task['db:seed -l'+Dir.pwd + "/seeds.rb"].invoke
#		end
#	end
	puts 'finished crawler engine db setup.'
end
