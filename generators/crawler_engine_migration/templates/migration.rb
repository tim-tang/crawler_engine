class CreateCrawlerEngine < ActiveRecord::Migration
	def self.up
		create_table :sources, :force => true do |t|
			t.string :site_name
			t.string :link
			t.string :filter
			t.string :category
			t.datetime :crawled_at # When to run. Could be Time.now for immediately, or sometime in the future.
		end
	end

	def self.down
		drop_table :sources
	end
end
