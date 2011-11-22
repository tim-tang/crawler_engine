#encoding:utf-8
require File.expand_path('../crawler_parser',__FILE__)
class CrawlerEngine
	@cp = CrawlerParser.new
    Source.create{
		:site_name =>""
		:title =>""
		:site_name =>""
		:site_name =>""
	}
	links = {
		#financial time chinese
		"http://www.ftchinese.com/rss/feed"=>'//div[@class="content"]',
		#
	}
	@cp.parse_post_rss(links)
end
