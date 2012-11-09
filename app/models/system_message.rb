class SystemMessage
	include Mongoid::Document
  	include Mongoid::Timestamps

  	belongs_to :notification
  	field :body, type: String
end