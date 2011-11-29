#encoding:utf-8
require File.expand_path('../post',__FILE__)

class HtmlGen
	def generate_from_db
		@posts = Post.find(:all)
		@posts.each do |post|
			generate(post)
		end
	end

	def generate(post)
	    log = Logger.new('/tmp/crawler_engine.log', 'daily')
	    log.level = Logger::INFO
		date=post.published_at.strftime("%Y%m%d")
		file_dir="#{RAILS_ROOT}/public/html_contents"
		#file_dir = File.expand_path('../public/html_contents', __FILE__)
		if File.exist?(file_dir)
			log.info("File directory already exists...")
			puts "File directory already exists..."
		else
			Dir.mkdir(file_dir)
		end
		if File.exist?(file_dir.concat("/"+date))
			log.info("Sub File exits...")
			puts "Sub File exits..."
		else
			Dir.mkdir(file_dir)
		end
		begin
			puts "Generating html for post >>"+post.title
			#file_name = file_dir+"/"+post.title.force_encoding('UTF-8')+".html"
			file_name = file_dir+"/#{post.id}.html"
			htmlFile = File.new(file_name, "w+")
			htmlFile.puts "<html><header><title>Everyday News</title><meta http-equiv=Content-Type content=text/html;charset=utf-8></header>"
			htmlFile.puts "<body>"
			htmlFile.puts "<h2>" + post.title.to_s.force_encoding('UTF-8') + "</h2>"
			htmlFile.puts post.content.force_encoding('UTF-8')
			htmlFile.puts "</body></html>"
			htmlFile.close()
		rescue Exception=>ex
			log.error("Got error while generate html #{ex}")
			puts ex
		end
	end
end

