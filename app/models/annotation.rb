class Annotation
	include Mongoid::Document
	include Mongoid::Timestamps

	field :about, type: String	
	field :mode, type: String
	
	embedded_in :custom_search_engnine
end