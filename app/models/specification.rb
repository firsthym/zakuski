class Specification
	include Mongoid::Document
	include Mongoid::Timestamps

	field :title, type: String
	field :description, type: String

	embedded_in :custom_search_engine
end