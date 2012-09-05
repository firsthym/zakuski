class Annotation
	include MongoMapper::EmbeddedDocument	
	belongs_to :custom_search_engnine
end