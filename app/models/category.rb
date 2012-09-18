class Category
	include Mongoid::Document
	field :item, type: Array
end