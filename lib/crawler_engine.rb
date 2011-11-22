#encoding:utf-8
require File.expand_path('../crawler_parser',__FILE__)
require File.expand_path('../source',__FILE__)

class CrawlerEngine
	@cp = CrawlerParser.new
	@sources = Source.find(:all)
	@cp.parse_rss(@sources)
end
