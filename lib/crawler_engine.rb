# encoding:utf-8
require File.expand_path('../crawler_parser',__FILE__)
require File.expand_path('../source',__FILE__)

class CrawlerEngine
	@cp = CrawlerParser.new
	#@sources = Source.find(:all)
	#@sources = Source.where(:id=>1)
	#@cp.parse_rss(@sources)
end
