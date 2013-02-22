class Node
	include Mongoid::Document
	include Mongoid::Timestamps

	field :title, type: String, localize: true
	field :description, type: String, localize: true
	field :weight, type: Integer, default: 0
	field :browse_count, type: Integer, default: 0

	#has_many :custom_search_engines
	has_many :topics
	has_many :tags

	def get_custom_search_engines(publish = true)
		tag_ids = self.tags.map { |tag| tag.id }
		if publish
		  CustomSearchEngine.recent.publish.from_tags(tag_ids)
		else
		  CustomSearchEngine.recent.from_tags(tag_ids)
		end 
	end

	def get_custom_search_engines_count
		tag_ids = self.tags.map { |tag| tag.id }
		CustomSearchEngine.recent.publish.from_tags(tag_ids).count
	end
	
	def get_posts(type = 'cses', publish = true)
		tag_ids = self.tags.map { |tag| tag.id }
		if publish
			Post.post_type(type).recent.publish.from_tags(tag_ids)
		else
			Post.post_type(type).recent.from_tags(tag_ids)
		end
	end

	def get_posts_count
		self.get_posts.count
	end

	# change id to title
	def to_param
	  title
	end
end
