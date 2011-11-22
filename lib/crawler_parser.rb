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
			#puts rss.feed_tags.title
			#puts rss.feed_tags.description

			for item in rss.items
				print_rss_item(item)
				#parse post details
				begin
					doc = Nokogiri::HTML open(item.link.to_s)
				rescue Exception=>ex
					#logger.error(ex)
					#logger.info("Nokogiri got unexpected error")
					puts ex
				end
				return unless doc
				doc.xpath(source.filter).each do |content|
					#puts content.to_s.force_encoding('GB2312')
					Iconv.iconv("GB2312//IGNORE","UTF-8//IGNORE", content)
					Post.create(
						:title=>item.title.to_s.force_encoding('UTF-8'),
						:source=>item.link.to_s.force_encoding('UTF-8'),
						:content=>content.to_s.force_encoding('UTF-8'),
						:published_at=>item.pubDate,
						:site_name=>source.site_name,
						:category => source.category)
				end
			end
			#update crawler exec timestamp
			source.update_attribute("crawled_at", Time.now)
		end
	end

	private
	def print_rss_item(item)
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
