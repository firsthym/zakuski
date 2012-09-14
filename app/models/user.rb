class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  field :username, type: String
  field :email, type: String
  field :password_digest, type: String
  field :agreement, type: Boolean
  
  attr_accessible :username, :email, :password, :password_confirmation, :agreement

  before_save { |user| user.email = email.downcase }

  validates :username, presence: true, length: {minimum: 2, maximum: 10}, uniqueness: {case_sensitive: false}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, \
            uniqueness:{case_sensitive: false}
  
  has_secure_password

  validates :password, length: {minimum: 6, maximum: 20}
  validates :password_confirmation, presence:true
  validates :agreement, presence: true

  # link to use the CSEs
  has_many :linking_custom_search_engines
  
  # create or fork the CSEs
  has_many :custom_search_engines

  belongs_to :vote
end
