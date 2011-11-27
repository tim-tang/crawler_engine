#encoding:utf-8
require File.expand_path('../post',__FILE__)
require File.expand_path('../html_gen',__FILE__)
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
		@html_gen=HtmlGen.new
		#logger.info("Links to crawl >>"+links.to_s)
		puts "Links to crawl >>"+sources.to_s
		sources.uniq!
		threads=[]
		sources.each do |source|
			threads << Thread.new do
				Thread.current["name"]=source.id
				puts "Create thread for num >>"+source.id.to_s
				begin
					rss = SimpleRSS.parse open(source.link)
				rescue Exception=>ex
					#logger.error(ex)
					#logger.info("SimpleRSS got unexpected error, rss exit")
					puts ex
				end

				for item in rss.items
					#print_rss_item(item)
					#puts "Post published date >>" + item.pubDate.to_s
					#puts "Crawler updated date >>" + source.crawled_at.to_s
					if item.pubDate >= source.crawled_at
						#print_rss_item(item)
						begin
							doc = Nokogiri::HTML open(item.link.to_s)
						rescue Exception=>ex
							#logger.error(ex)
							#logger.info("Nokogiri got unexpected error")
							puts ex
						end
						return unless doc
						doc.xpath(source.filter).each do |content|
							begin
								#Iconv.iconv("GB2312//IGNORE","UTF-8//IGNORE", content)
								#Iconv.iconv("UTF-8//IGNORE","GB2312//IGNORE", content)
								@post = Post.new
								@post.title=item.title.to_s.force_encoding('UTF-8')
								@post.source=item.link.to_s.force_encoding('UTF-8')
								#puts content.to_s.force_encoding('UTF-8')
								@post.content=content.to_s.force_encoding('UTF-8')
								if content.to_s.scan(/<img[^<^{^(]+src=['"]{0,1}([^>^\s^"]*)['"]{0,1}[^>]*>/im).size>0
								   @post.thumbnail=content.to_s.scan(/<img[^<^{^(]+src=['"]{0,1}([^>^\s^"]*)['"]{0,1}[^>]*>/im)[0][0].to_s.force_encoding('UTF-8')
								end
																  @post.published_at=item.pubDate
																  @post.site_name=source.site_name
																  @post.category=source.category
																  @post.save(@post)
																  @html_gen.generate(@post)
							rescue Exception=>ex
								puts ex
							end
						end
					end
				end
				#update crawler exec timestamp
				source.update_attribute("crawled_at", Time.now)
			end
		end
		# thread end stop treads finally.
		threads.each do |thread|
			thread.join
			puts "stop thread num >> #{thread.inspect}:#{thread[:name]}"
		end
	end

	private
	def print_rss_item(item)
		puts "-" * FS_LEN
		puts "title:" + item.title.to_s
		puts "author:" + item.author.to_s
		puts "description:" + item.description.to_s
		#puts Iconv.iconv("UTF-8//IGNORE","GB2312//IGNORE",item.description.to_s )
		puts "link:" + item.link.to_s
		puts "pubDate:" + item.pubDate.to_s
		puts "guid:" + item.guid.to_s
		puts "category:" + item.category.to_s
	end
end
