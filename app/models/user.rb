class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  validates_presence_of :email
  validates_presence_of :encrypted_password
  
  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String

  field :username, type: String
  field :email, type: String
  field :password_digest, type: String
  field :agreement, type: Boolean, default: false
  field :admin, type: Boolean, default: false
  field :remember_token, type: String

  # keep the CSEs
  has_and_belongs_to_many :keeped_custom_search_engines, class_name: 'CustomSearchEngine', inverse_of: :consumers
  
  # create or fork the CSEs
  has_many :custom_search_engines, class_name: 'CustomSearchEngine', inverse_of: :author, dependent: :destroy

  has_many :topics, dependent: :destroy
  has_many :replies, dependent: :destroy

  belongs_to :vote

  # Index
  index({remember_token: 1}, {unique: true, name: 'user_remember_token'})
  index({username: 1}, {unique: true, name: 'user_username'})
  index({email: 1}, {unique: true, name: 'user_email'})

  # Massive assignment for User.new
  attr_accessible :username, :email, :password, :password_confirmation, :agreement

  validates :agreement, presence: true
  validates :username, presence: true, length: {minimum: 2, maximum: 10}, uniqueness: {case_sensitive: false}
 
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, \
            uniqueness:{case_sensitive: false}
  
  has_secure_password

  validates :password, length: {minimum: 6, maximum: 20}
  validates :password_confirmation, presence:true

  before_save { |user| user.email.try(:downcase) }
  before_save :create_remember_token

  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
