#encoding:utf-8
require File.expand_path('../post',__FILE__)
require 'nokogiri'
require 'rest-open-uri'
require 'simple-rss'
require 'iconv'
require 'logger'

class CrawlerParser
	#logger = Logger.new('/tmp/crawlerEngine.log', 'daily')
	#logger.level = Logger::INFO
	FS_LEN = 80

	def create(title, link, content, pubDate)
		@post= Post.new
		@post.title= title.to_s.force_encoding('UTF-8')
		@post.source= link.to_s.force_encoding('UTF-8')
		@post.content= content.to_s.force_encoding('UTF-8')
		@post.published_at= pubDate.to_s.force_encoding('UTF-8')
		@post.save
	end

	def parse_rss(sources)
		return if sources.nil? or sources.size.eql?(0)
		#logger.info("Links to crawl >>"+links.to_s)
		puts "Links to crawl >>"+sources.to_s
		sources.uniq!
		sources.each do |source|
			begin
				rss = SimpleRSS.parse open(source.link)
			rescue Exception=>ex
				#logger.error(ex)
				#logger.info("SimpleRSS got unexpected error, rss exit")
				puts ex
			end
			#TODO:
			puts rss.feed_tags.title
			puts rss.feed_tags.description

			for item in rss.items
				print_rss_item(item)
				#parse post details
				begin
				doc = Nokogiri::HTML.parse(open(item.link.to_s), nil, "UTF-8")
				rescue Exception=>ex
					#logger.error(ex)
					#logger.info("Nokogiri got unexpected error")
					puts ex
				end
				return unless doc
				doc.xpath(filter).each do |content|
					Iconv.iconv("GB2312//IGNORE","UTF-8//IGNORE", content)
					create(item.title, item.link, content, item.pubDate)
				end
			end
			#update crawler exec timestamp
            source.update_attribute("crawled_at", Time.now)
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
