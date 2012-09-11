class CustomSearchEngine
  include Mongoid::Document
  include Mongoid::Timestamps

  field :voters, type: Array
  field :votes, type: Integer, default: 0
  field :access, type: String
  field :current_links, type: Integer, default: 1
  field :history_links, type: Integer, default: 1

  attr_accessible :access
  # validations
  validates :access, presence: true, inclusion: {in: ['public', 'protected', 'private']}

  # custom search engine specification
  embeds_one :specification
  
  # custom search engine annotations
  embeds_many :annotations

  embeds_many :comments

  accepts_nested_attributes_for :annotations, allow_destroy: true
  accepts_nested_attributes_for :specification, allow_destroy: true

  belongs_to :user
  belongs_to :linking_custom_search_engine
  belongs_to :category
  
end
