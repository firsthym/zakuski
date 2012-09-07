class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :username, type: String
  field :email, type: String
  field :password, type: String
  field :agreement, type: Boolean
  
  # link to use the CSEs
  has_many :linking_custom_search_engines
  
  # create or fork the CSEs
  has_many :custom_search_engines

  has_many :comments

end
