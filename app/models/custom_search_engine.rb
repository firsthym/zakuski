class CustomSearchEngine < Post
	field :status, type: String

	# consumers
	field :consumers, type: Array, default: []

	field :parent_id, type: String
	field :children_ids, type: Array, default: []

	# custom search engine specification
	embeds_one :specification
	
	embeds_many :labels
	
	# custom search engine annotations
	embeds_many :annotations
	
	has_one :theme

	accepts_nested_attributes_for :specification
	accepts_nested_attributes_for :labels, allow_destroy: true, 
																reject_if: proc { |attr| attr[:name].blank? }
	accepts_nested_attributes_for :annotations, allow_destroy: true, 
																reject_if: proc { |attr| attr[:about].blank? }
	accepts_nested_attributes_for :theme
	
	attr_accessible :specification_attributes, :labels_attributes,
		:annotations_attributes, :theme_attributes

	# validations
	validates :status, presence: true, inclusion: {in: ['draft', 'publish']}
	validates :author_id, presence: true
	validates :tag_ids, presence: true, unless: Proc.new { |cse| cse.is_cloned }

	#scope :recent, desc(:updated_at)
	#scope :publish, where(status: 'publish')
	#scope :draft, where(status: 'draft')
	#scope :hot, desc(:keep_count)
	#scope :from_tags, ->(tag_ids) { where(:tag_ids.in => tag_ids) }
	
	before_save :check_labels

	attr_accessor :keeped_at
	attr_accessor :is_cloned

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
			[]
		end
	end

	def self.get_hot_cses(limit = 5, post_type = 'cses')
		hot_tags = Tag.desc(:browse_count).limit(limit)
		hot_tags.collect { |t| t.posts.type(post_type).hot.limit(1).first }.compact.uniq { |c| c.id }
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
