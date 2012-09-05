class Comment
	include MongoMapper::EmbeddedDocument
	belongs_to :custom_search_engine
end