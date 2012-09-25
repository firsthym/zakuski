class Node
	include Mongoid::Document
	include Mongoid::Timestamps

	field :title, type: String, localize: true
	field :description, type: String, localize: true

	# index
	index({title: 1}, {name: 'node_title'})

end