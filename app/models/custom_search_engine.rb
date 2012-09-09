class CustomSearchEngine
  include Mongoid::Document
  include Mongoid::Timestamps

  field :voters, type: Array
  field :votes, type: Integer, default: 0
  field :access, type: String
  field :current_links, type: Integer, default: 1
  field :history_links, type: Integer, default: 1

  # custom search engine specification
  embeds_one :specification
  
  # custom search engine annotations
  embeds_many :annotations

  has_many :comments

  belongs_to :user
  belongs_to :linking_custom_search_engine
  belongs_to :category
  
end
