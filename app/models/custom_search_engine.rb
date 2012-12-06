class CustomSearchEngine
  include Mongoid::Document
  include Mongoid::Timestamps
  paginates_per 20

  #field :access, type: String, default: 'public'
  field :parent_id
  field :status, type: String
  #field :keep_count, type: Integer, default: 0
  field :browse_count, type: Integer, default: 0

  # consumers
  field :consumers, type: Array, default: []

  # custom search engine specification
  embeds_one :specification
  
  # custom search engine annotations
  embeds_many :annotations

  embeds_many :votes

  has_many :replies
  has_and_belongs_to_many :tags

  belongs_to :author, class_name: 'User', inverse_of: :custom_search_engines
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

  scope :recent, desc(:updated_at)
  scope :publish, where(status: 'publish')
  scope :draft, where(status: 'draft')
  scope :hot, desc(:keep_count)
  #scope :dashboard, desc(:dashboard_index)

  #TBD
  def self.get_default_cse
    cse_array = self.build_parent(self.publish.hot)
    cse_array.first
  end

  def self.get_from_cookie(cookie, limit = 10)
    self.build_parent(self.publish.in(id: cookie.split(',')[0,limit]).limit(limit).compact)
  end

  def self.get_hot_cses(limit = 10)
    self.build_parent(self.publish.hot.limit(limit).compact)
  end

  def get_consumers
    User.in(id: self.consumers.map{|each| each["uid"]}).compact
  end

  def self.build_parent(custom_search_engines)
    parent_ids = custom_search_engines.map{|cse| cse.parent_id if cse.parent_id.present?}
    parent_cses = self.in(id: parent_ids).compact
    custom_search_engines.each do |cse|
      cse[:parent] = nil
      parent_cses.each do |pcse|
        if cse.parent_id.present? && cse.parent_id == pcse.id
          cse[:parent] = pcse
          break
        end
      end
    end
  end

  def keep_count
    self.consumers.count
  end
 
  def publish?
    if self.status == 'publish'
	true
    else
        false
    end
  end

end
