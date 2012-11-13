class CustomSearchEngine
  include Mongoid::Document
  include Mongoid::Timestamps
  paginates_per 20

  #field :access, type: String, default: 'public'
  field :parent_id
  field :status

  # custom search engine specification
  embeds_one :specification
  
  # custom search engine annotations
  embeds_many :annotations

  embeds_many :votes

  has_many :replies

  belongs_to :author, class_name: 'User', inverse_of: :custom_search_engines
  has_and_belongs_to_many :consumers, class_name: 'User', inverse_of: :keeped_custom_search_engines
  belongs_to :node

  # Index
  index({author_id: 1}, {name: 'cse_author_id'})
  index({node_id: 1}, {name: 'cse_node_id'})

  accepts_nested_attributes_for :annotations, allow_destroy: true
  accepts_nested_attributes_for :specification

  attr_accessible :specification_attributes, :annotations_attributes, :node_id

  # validations
  #validates :access, presence: true, inclusion: {in: ['public', 'protected', 'private']}
  validates :status, presence: true, inclusion: {in: ['draft', 'publish']}
  validates :author_id, presence: true
  validates :node_id, presence: true

  scope :recent, ->(status) { where(status: status).desc(:created_at) }
  
  def self.get_hot_cses
    self.all
  end

  def self.get_default_cse
    self.first
  end
end
