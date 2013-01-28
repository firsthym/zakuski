class Tag
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  validates :name, presence: true

  has_and_belongs_to_many :custom_search_engines
  belongs_to :node

end
