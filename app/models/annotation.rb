class Annotation
	include Mongoid::Document
	include Mongoid::Timestamps

	field :about, type: String	
	
	embedded_in :custom_search_engnine
end