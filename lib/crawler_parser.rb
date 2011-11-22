#encoding:utf-8
require File.expand_path('../post',__FILE__)
require 'nokogiri'
require 'rest-open-uri'
require 'simple-rss'
require 'iconv'
require 'logger'

class CrawlerParser
	logger = Logger.new('/tmp/crawlerEngine.log', 10, 1024000)
	logger.level = Logger::INFO
	FS_LEN = 80

	def create(title, link, content, pubDate)
		@post= Post.new
		@post.title= title.to_s.force_encoding('UTF-8')
		@post.source= link.to_s.force_encoding('UTF-8')
		@post.content= content.to_s.force_encoding('UTF-8')
		@post.published_at= pubDate.to_s.force_encoding('UTF-8')
		@post.save
	end

	def parse_rss(links)
		return if links.nil? or links.size.eql?(0)
		logger.info("Links to crawl >>"+links.to_s)
		links.uniq!
		links.each do |link, filter|
			begin
				rss = SimpleRSS.parse open(link)
			rescue Exception=>ex
				logger.error(ex)
				logger.info("SimpleRSS got unexpected error, rss exit")
			end
			#TODO:
			puts rss.feed_tags.title
			puts rss.feed_tags.description

			for item in rss.items
				print_rss_item(item)
				#parse post details
				begin
				doc = Nokogiri::HTML.parse(open(link), nil, "UTF-8")
				rescue Exception=>ex
					logger.error(ex)
					logger.info("Nokogiri got unexpected error")
				end
				return unless doc
				doc.xpath(filter).each do |content|
					Iconv.iconv("GB2312//IGNORE","UTF-8//IGNORE", content)
					create(item.title, item.link, content, item.pubDate)
				end
			end
		end
	end

	private
	def print_rss_item
		puts "-" * FS_LEN
		puts "title:" + item.title.to_s
		puts "author:" + item.author.to_s
		puts "description:" + item.description.to_s
		puts "link:" + item.link.to_s
		puts "pubDate:" + item.pubDate.to_s
		puts "guid:" + item.guid.to_s
		puts "category:" + item.category.to_s
	end
end
