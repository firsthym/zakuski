class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :username, type: String
  field :email, type: String
  field :password, type: String
  field :agreement, type: Boolean
  
  attr_accessible :username, :email, :password, :agreement

  validates :username, presence: true, length: {minimum: 2, maximum: 10}, uniqueness: {case_sensitive: false}
  validates :email, presence: true, format: {with: /\A[a-zA-Z0-9]+@[a-zA-Z0-9]+\.com|cn|org|net|cc|so|me\z/}
  validates :password, presence: true
  validates :agreement, presence: true

  # link to use the CSEs
  has_many :linking_custom_search_engines
  
  # create or fork the CSEs
  has_many :custom_search_engines

  has_many :comments

  belongs_to :vote
end
