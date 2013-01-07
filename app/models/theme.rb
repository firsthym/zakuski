class Theme
	include Mongoid::Document
	field :name, type: String, default: "default"

	belongs_to :custom_search_engine
end
