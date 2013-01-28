class CustomSearchEngine
  include Mongoid::Document
  include Mongoid::Timestamps
  paginates_per 20

  field :status, type: String
  field :browse_count, type: Integer, default: 0

  # consumers
  field :consumers, type: Array, default: []

  field :parent_id, type: String
  field :children_ids, type: Array, default: []

  # custom search engine specification
  embeds_one :specification
  
  embeds_many :labels
  
  # custom search engine annotations
  embeds_many :annotations
  

  has_many :replies
  has_and_belongs_to_many :tags
  has_one :theme

  belongs_to :author, class_name: 'User', inverse_of: :custom_search_engines
  belongs_to :node


  # Index
  index({author_id: 1}, {name: 'cse_author_id'})
  index({node_id: 1}, {name: 'cse_node_id'})

  accepts_nested_attributes_for :specification
  accepts_nested_attributes_for :labels, allow_destroy: true, 
                                reject_if: proc { |attr| attr[:name].blank? }
  accepts_nested_attributes_for :annotations, allow_destroy: true, 
                                reject_if: proc { |attr| attr[:about].blank? }
  accepts_nested_attributes_for :theme
  
  attr_accessible :node_id, :specification_attributes, :labels_attributes,
    :annotations_attributes, :theme_attributes, :tag_ids

  # validations
  validates :status, presence: true, inclusion: {in: ['draft', 'publish']}
  validates :author_id, presence: true
  validates :node_id, presence: true

  scope :recent, desc(:updated_at)
  scope :publish, where(status: 'publish')
  scope :draft, where(status: 'draft')
  scope :hot, desc(:keep_count)
  
  before_save :check_labels

  attr_accessor :keeped_at

  # callbacks for Marshal.dump
  def _dump level
    [self.id, self.keeped_at.to_i].join(':')
  end

  # callbacks for Marshal.load
  def self._load args
    params = *args.split(':')
    id = params[0]
    keeped_at = Time.at(params[1].to_i)
    cse = self.find(id)
    if cse.present?
      cse.keeped_at = keeped_at
      cse
    else
      nil
    end
  end

  #TBD
  def self.get_default_cse
    self.publish.hot.compact.first
  end

  def self.get_from_cookie(cookie, limit = 10)
    #self.publish.in(id: cookie.split(',')[0,limit]).limit(limit).compact
    begin
      Marshal.load(cookie).compact
    rescue
      logger.debug "cookie -- #{cookie}"
      []
    end
  end

  def self.get_hot_cses(limit = 10)
    self.publish.hot.limit(limit).compact
  end

  def get_consumers
    User.in(id: self.consumers.map{|each| each["uid"]}).compact
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
  
  def parent
   CustomSearchEngine.find(self.parent_id) if self.parent_id.present? 
  end
  
  def parent=(custom_search_engine)
    self.parent_id = custom_search_engine.id.to_s
    unless custom_search_engine.children_ids.include? self.id
      custom_search_engine.children_ids.push self.id
      custom_search_engine.save
    end
  end
  
  def children
    cses_on_db = CustomSearchEngine.in(id: self.children_ids)
    cses_ids_on_db = cses_on_db.map { |cse| cse.id }
    self.children_ids &= cses_ids_on_db
    self.save
    cses_on_db 
  end

  private
    def check_labels
      labels = self.labels.map{ |l| l.name unless l.marked_for_destruction? }
      self.annotations.each do |a|
        a.labels_list = a.labels_list & labels
      end
    end
end
