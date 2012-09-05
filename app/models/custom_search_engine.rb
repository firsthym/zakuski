class CustomSearchEngine
  include MongoMapper::EmbeddedDocument
  key :author_uid, ObjectId, required: true
  key :category, Integer, required: true
  key :access, Integer, default: 0, required: true
  key :voters, Array
  key :votes, Integer, default: 0
  key :current_links, Integer, default: 1
  key :history_links, Integer, default: 1

  # custom search engine specification
  one :specification
  # custom search engine annotations
  many :annotations

  many :comments
  timestamps!

  belongs_to :user
  
  attr_accessible :category, :access, :voters, :votes

end
