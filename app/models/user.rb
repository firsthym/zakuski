class User
  include MongoMapper::Document

  key :username, String
  key :email, String
  key :password, String
  key :agreement, Boolean
  #attr_accessor :password_confirmation
end
