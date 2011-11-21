#encoding:utf-8
require File.expand_path('../post',__FILE__)
require 'nokogiri'
require 'rest-open-uri'
require 'simple-rss'
require 'iconv'

class CrawlerEngine
	FS_LEN = 80
	def create(title, link, content, pubDate)
		@post= Post.new
		@post.title= title.to_s.force_encoding('UTF-8')
		@post.source= link.to_s.force_encoding('UTF-8')
		@post.content= content.to_s.force_encoding('UTF-8')
		@post.published_at= pubDate.to_s.force_encoding('UTF-8')
		@post.save
	end


	def get_post_rss(links)
		return if links.nil? or links.size.eql?(0)
		puts links.to_s
		links.uniq!
		links.each {|link|
			puts "*" * FS_LEN
			begin
				rss = SimpleRSS.parse open(link)
			rescue Exception=>ex
				puts ex
				puts "rss exit"
			end

			puts "-" * FS_LEN

			for item in rss.items
				puts "-"*50
				puts "title:" + item.title.to_s
				puts "author:" + item.author.to_s
				puts "description:" + item.description.to_s
				puts "link:" + item.link.to_s
				puts "pubDate:" + item.pubDate.to_s
				puts "guid:" + item.guid.to_s
				puts "category:" + item.category.to_s
				get_post_details(item.title.to_s, item.link.to_s, item.pubDate.to_s)
			end
		}
	end

	def get_post_details(title, link, pubDate)
		doc = Nokogiri::HTML.parse(open(link), nil, "UTF-8")
		return unless doc
		doc.xpath('//div[@class="content"]').each do |content|
		#doc.xpath('//div[@class="postcont"]').each do |content|
		    Iconv.iconv("GB2312//IGNORE","UTF-8//IGNORE", content)
			create(title, link, content, pubDate)
		end
	end
end


@ce = CrawlerEngine.new
#@ce.get_post_rss
links = Array.new
#links << 'yeeyan-select'
links << "http://www.ftchinese.com/rss/feed"
#links << "http://feed.feedsky.com/my1510"
#@e.get_post_details(links)
@ce.get_post_rss(links)
