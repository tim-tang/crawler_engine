#encoding:utf-8
require File.expand_path('../post',__FILE__)
require 'logger'
require 'active_record'
require 'rest-open-uri'


class HtmlGen
	def generate_posts(last_crawled)
		ActiveRecord::Base.transaction do
			begin
				sql = ActiveRecord::Base.connection()
				sql.insert "create table tmp select max(id) as id from posts group by title"
				sql.insert "delete from posts where id not in(select id from tmp)"
				sql.insert "drop table tmp"
			rescue Exception => ex
				# ex.message
				raise ActiveRecord::Rollback, ex.message # rollback
			end
		end
		puts "Last Crawled time at #{last_crawled}"
		@posts = Post.find_by_sql("select * from posts where published_at > '#{last_crawled.strftime("%Y-%m-%d %H:%M:%S")}'")
		#@posts = Post.find_by_sql("select * from posts where published_at > #{last_crawled}")
		@posts.each do |post|
			generate(post)
		end
	end

	def generate(post)
		log = Logger.new('/tmp/crawler_engine.log', 'daily')
		log.level = Logger::INFO
		date=post.published_at.strftime("%Y%m%d")
		file_dir="#{Rails.root.to_s}/public/html_contents"
		#file_dir = File.expand_path('../public/html_contents', __FILE__)
		if File.exist?(file_dir)
			log.info("File directory already exists...")
		else
			Dir.mkdir(file_dir)
		end
		if File.exist?(file_dir.concat("/"+date))
			log.info("Sub File exits...")
		else
			Dir.mkdir(file_dir)
		end
		# download image to local
		generate_img(post, file_dir, log)
		begin
			log.info("Generating html for post >> #{post.title}")
			puts "Generating html for post >> #{post.title}"
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

	def generate_img(post, file_dir, log)
		begin
		if post.thumbnail!= nil
			open(post.thumbnail) do |data|
				new_image = File.new(file_dir+"/#{post.id}.png", "w")
				new_image.puts data.read.to_s.force_encoding('UTF-8')
				new_image.close
			end
		end
		rescue Exception=>ex
		  log.error("Can't download connection: #{ex}")
		  puts "Can't download connection: #{ex}"
		end
	end
end
#@gen = HtmlGen.new
#@gen.generate_from_db
