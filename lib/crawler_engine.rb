# encoding:utf-8
require File.expand_path('../crawler_parser',__FILE__)
require File.expand_path('../source',__FILE__)

module CrawlerEngine
	class << self
		def start
			@cp = CrawlerParser.new
			@sources = Source.find(:all)
			#puts @sources.to_s
			@cp.parse_rss(@sources)
		end
	end
end
#CrawlerEngine.start
#@ce.start
