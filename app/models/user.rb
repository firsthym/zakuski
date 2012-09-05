class User
  include MongoMapper::Document

  key :username, String, required: true
  key :email, String, required: true, unique: true
  key :password, String, required: true
  key :agreement, Boolean, required: true
  #attr_accessor :password_confirmation

  many :custom_search_engines

  timestamps!

end
