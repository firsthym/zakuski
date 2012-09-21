class CustomSearchEngine
  include Mongoid::Document
  include Mongoid::Timestamps

  field :access, type: String, default: 'public'
  field :current_links, type: Integer, default: 1
  field :history_links, type: Integer, default: 1
  
  # custom search engine specification
  embeds_one :specification
  
  # custom search engine annotations
  embeds_many :annotations

  embeds_many :comments

  embeds_many :votes

  belongs_to :user
  belongs_to :linking_custom_search_engine
  belongs_to :category

  # Index
  index user_id: 1
  index category_id: 1

  accepts_nested_attributes_for :annotations, allow_destroy: true
  accepts_nested_attributes_for :specification

  attr_accessible :access, :specification_attributes, :annotations_attributes, :category_id

  # validations
  validates :access, presence: true, inclusion: {in: ['public', 'protected', 'private']}
  validates :user_id, presence: true
  validates :category_id, presence: true
  
end
