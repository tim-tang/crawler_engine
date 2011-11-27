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
		begin
			puts "Generating html for post >>"+post.title
			file_dir = File.expand_path('../public/html_contents', __FILE__)
			file_name = file_dir+"/"+post.id.to_s+".html"
			htmlFile = File.new(file_name, "w+")
			htmlFile.puts "<html><header><title>Everyday News</title><meta http-equiv=Content-Type content=text/html;charset=utf-8></header>"
			htmlFile.puts "<body>"
			htmlFile.puts "<h2>" + post.title.to_s.force_encoding('UTF-8') + "</h2>"
			htmlFile.puts post.content.force_encoding('UTF-8')
			htmlFile.puts "</body></html>"
			htmlFile.close()
		rescue Exception=>ex
			puts ex
		end
	end
end

