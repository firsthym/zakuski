class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  field :username, type: String
  field :email, type: String
  field :password_digest, type: String
  field :agreement, type: Boolean
  field :remember_token, type: String

  # link to use the CSEs
  has_many :linking_custom_search_engines
  
  # create or fork the CSEs
  has_many :custom_search_engines

  belongs_to :vote

  # Index
  index({remember_token: 1}, {unique: true, name: 'remember_token_index'})
  index({username: 1}, {unique: true, name: 'username_index'})
  index({email: 1}, {unique: true, name: 'email_index'})

  # Massive assignment for User.new
  attr_accessible :username, :email, :password, :password_confirmation, :agreement

  validates :username, presence: true, length: {minimum: 2, maximum: 10}, uniqueness: {case_sensitive: false}
 
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, \
            uniqueness:{case_sensitive: false}
  
  has_secure_password

  validates :password, length: {minimum: 6, maximum: 20}
  validates :password_confirmation, presence:true
  validates :agreement, presence: true

  before_save { |user| user.email.try(:downcase) }
  before_save :create_remember_token

  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
