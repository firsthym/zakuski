class CustomSearchEngine
  include MongoMapper::Document

  key :name, String
  key :description, String

end
