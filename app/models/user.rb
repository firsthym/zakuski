class User
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable, :timeoutable, :confirmable

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  #validates_presence_of :email
  #validates_presence_of :encrypted_password
  
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
  field :confirmation_token,   :type => String
  field :confirmed_at,         :type => Time
  field :confirmation_sent_at, :type => Time
  field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String
  
  # ==> Below are customize fields
  field :email_public, type: Boolean, default: true
  field :username, type: String
  validates :username, presence: true, length: {minimum: 2, maximum: 20}, 
            uniqueness: {case_sensitive: false}

  field :mood, type: String
  validates :mood, length: {maximum: 20}

  # dashboard CSEs
  field :dashboard_cses, type: Array, default: []
  # keeped CSEs including ids and keep-time
  field :keeped_cses, type: Array, default: []

  mount_uploader :avatar, AvatarUploader

  # created or cloned the CSEs
  has_many :custom_search_engines, inverse_of: :author, dependent: :destroy

  has_many :topics, dependent: :destroy
  has_many :replies, dependent: :destroy
  has_many :notifications, dependent: :destroy

  belongs_to :vote

  # Index
  index({username: 1}, {unique: true, name: 'user_username'})
  index({email: 1}, {unique: true, name: 'user_email'})

  # Massive assignment for User.new
  attr_accessible :email, :username, :agreement, :password, :password_confirmation, :avatar, :mood
  attr_accessor :password_confirmation
  validates :password_confirmation, presence: true, on: :create
  # validates :agreement, presence: true, on: :create
 
  def own_cse?(custom_search_engine)
    if self.custom_search_engines.include? custom_search_engine
      true
    elsif self.custom_search_engines.map{|cse| cse.parent_id}.include? custom_search_engine.id
      true
    else
      false
    end
  end

  def mark_read(notifications)
    if notifications.present?
      ids = notifications.map{|cse| cse.id}
      Notification.in(id: ids).update_all(read: true)
    else
      false
    end
  end

  def get_dashboard_cses
    cses_on_db = CustomSearchEngine.in(id: self.dashboard_cses.map{|each| each["id"]}).limit(10).compact
    ids = cses_on_db.map { |cse| cse.id }
    self.dashboard_cses.each do |hash|
      unless ids.include? hash["id"]
        self.dashboard_cses.delete(hash)
      end  
    end
    self.update if self.changed?
    cses_on_db
  end

  def set_dashboard_cses(custom_search_engines)
    if custom_search_engines.present?
      ids = custom_search_engines.map { |cse| cse.id }
      self.dashboard_cses.clear
      ids.each {|id| self.dashboard_cses.push Hash["id", id]} if ids.any?
      self.update
    else
      false
    end
  end

  def get_keeped_cses
    keeped_cses = CustomSearchEngine.in(id: self.keeped_cses.map{|each| each["id"]}).recent.publish.limit(20).compact
    ids = keeped_cses.map { |cse| cse.id }
    self.keeped_cses.each do |hash|
      unless ids.include?(hash["id"])
        self.keeped_cses.delete(hash)
      end
    end
    self.update if self.changed?
    keeped_cses.each do |cse|
      self.keeped_cses.each do |hash|
        cse[:keeped_at] = hash["time"] if hash["id"] == cse.id
      end
    end.sort { |x,y| y.keeped_at <=> x.keeped_at}
  end

  def get_created_cses
    self.custom_search_engines.recent.compact
  end

  def set_keeped_cses(custom_search_engines)
    if custom_search_engines.present?
      ids = custom_search_engines.map{ |cse| cse.id}
      self.keeped_cses.each do |hash|
        unless ids.include?(hash["id"])
          self.keeped_cses.delete(hash)
        end
      end
      self.update if self.changed?
    else
      false
    end
  end

  def keeps_cse(custom_search_engine)
    time = Time.now
    has_keeped_cse_ids = self.keeped_cses.map { |hash| hash["id"] }
    unless has_keeped_cse_ids.include?(custom_search_engine.id)
      self.keeped_cses.push(Hash["id", custom_search_engine.id, "time", time])
    end
    has_added_to_dashboard_cse_ids = self.dashboard_cses.map { |hash| hash["id"] }
    unless has_added_to_dashboard_cse_ids.include? custom_search_engine.id
      if self.dashboard_cses.count < 10
        self.dashboard_cses.push(Hash["id", custom_search_engine.id])
      end
    end
    self.keeped_cses = self.keeped_cses.uniq { |hash| hash["id"]}
    self.dashboard_cses = self.dashboard_cses.uniq { |hash| hash["id"]}

    if self.save
      uids = custom_search_engine.consumers.map { |consumer| consumer["uid"] }
      unless uids.include? self.id
        custom_search_engine.consumers.push(Hash["uid", self.id, "time", time])
      end
      custom_search_engine.consumers = custom_search_engine.consumers.uniq { |hash| hash["uid"]}
      custom_search_engine.save
    end
  end

  def removes_cse(custom_search_engine)
    self.keeped_cses.delete_if{|each| each["id"] == custom_search_engine.id}
    self.dashboard_cses.delete_if{|each| each["id"] == custom_search_engine.id}
    self.update(validate: false)

    custom_search_engine.consumers.delete_if{|each| each["uid"] == self.id}
    custom_search_engine.update
  end

  def to_param
    username
  end

end
