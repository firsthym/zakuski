class Specification
	include MongoMapper::EmbeddedDocument
	belongs_to :custom_search_engnine
end