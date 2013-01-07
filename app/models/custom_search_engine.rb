class CustomSearchEngine
  include Mongoid::Document
  include Mongoid::Timestamps
  paginates_per 20

  field :parent_id
  field :status, type: String
  field :browse_count, type: Integer, default: 0

  # consumers
  field :consumers, type: Array, default: []

  # custom search engine specification
  embeds_one :specification
  
  embeds_many :labels
  
  # custom search engine annotations
  embeds_many :annotations
  
  has_many :replies
  has_and_belongs_to_many :tags

  belongs_to :author, class_name: 'User', inverse_of: :custom_search_engines
  belongs_to :node

  # Index
  index({author_id: 1}, {name: 'cse_author_id'})
  index({node_id: 1}, {name: 'cse_node_id'})

  accepts_nested_attributes_for :specification, reject_if: proc { |attr| attr[:title].blank? }
  accepts_nested_attributes_for :labels, allow_destroy: true, reject_if: proc { |attr| attr[:name].blank? }
  accepts_nested_attributes_for :annotations, allow_destroy: true, reject_if: proc { |attr| attr[:about].blank? }

  attr_accessible :node_id, :specification_attributes, :labels_attributes, :annotations_attributes

  # validations
  validates :status, presence: true, inclusion: {in: ['draft', 'publish']}
  validates :author_id, presence: true
  validates :node_id, presence: true

  scope :recent, desc(:updated_at)
  scope :publish, where(status: 'publish')
  scope :draft, where(status: 'draft')
  scope :hot, desc(:keep_count)
  
  before_save :check_labels

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
  
  private
  	def check_labels
  		labels = self.labels.map{ |l| l.name unless l.marked_for_destruction? }
  		self.annotations.each do |a|
			a.labels_list = a.labels_list & labels
		end
  	end
end
