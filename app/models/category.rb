class Category
	include Mongoid::Document
	field :title, type: String, localize: true
	field :description, type: String, localize: true

	recursively_embeds_one
	
	has_many :custom_search_engines

end