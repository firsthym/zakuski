class Label
  include Mongoid::Document
  field :name, type: String
  field :mode, type: String, default: 'filter'
  field :weight, type: Integer, default: 10
  
  attr_accessor :cse_destroy
  attr_accessible :name, :mode, :cse_destroy
  
  validates :name, uniqueness: true
  validates :mode, inclusion: { in: ['filter', 'exclude', 'boost'] }
  validates :weight, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than: 11 }

  embedded_in :custom_search_engine
end
