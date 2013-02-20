class Notification
	include Mongoid::Document
	include Mongoid::Timestamps
	paginates_per 20

	belongs_to :user
	#has_many :system_messages, dependent: :destroy
	#has_many :user_messages, dependent: :destroy

	field :title, type: String
	field :body, type: String
	field :from, type: String, default: 'system'
	field :source, type: String
	field :sender_id
	field :read, type: Boolean, default: false

	validates :title, presence: true
	validates :source, presence: true, inclusion: {in: ['discus', 'cse']}
	validates :user_id, presence: true

	# Scope
	scope :recent, ->(source) { where(source: source).desc(:created_at) }
	scope :all_unread, ->(source) { where({source: source, read: false}) }
	scope :today_unread, ->(source) { where({source: source, read: false, 
		:created_at.gt => Time.now.at_beginning_of_day()}) }

	def self.messager(option)
		new_notification = self.create(title: option[:title], body: option[:body],
								from: option[:from] || 'system', source: option[:source],
								user_id: option[:receiver].id, read: false, sender_id: option[:sender].id)
	end

end