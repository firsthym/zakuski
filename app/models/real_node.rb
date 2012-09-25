class RealNode < Node
	recursively_embeds_one

	has_many :custom_search_engines
	has_many :topics
end