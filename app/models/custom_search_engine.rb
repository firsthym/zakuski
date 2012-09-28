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

  embeds_many :votes

  has_many :replies

  belongs_to :author, class_name: 'User', inverse_of: :custom_search_engines
  has_and_belongs_to_many :linkers, class_name: 'User', inverse_of: :linking_custom_search_engines
  belongs_to :node

  # Index
  index({author_id: 1}, {name: 'cse_author_id'})
  index({node_id: 1}, {name: 'cse_node_id'})

  accepts_nested_attributes_for :annotations, allow_destroy: true
  accepts_nested_attributes_for :specification

  attr_accessible :access, :specification_attributes, :annotations_attributes, :node_id

  # validations
  validates :access, presence: true, inclusion: {in: ['public', 'protected', 'private']}
  validates :author_id, presence: true
  validates :node_id, presence: true

  before_save {|cse| cse.node.instance_of? RealNode}
  
end
