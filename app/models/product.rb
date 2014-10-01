class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :name, type: String
  field :price, type: Integer
  field :image, type: String
  field :quantity, type: Integer
  field :pack_size, type: Integer
  field :initial_cost, type: Float
  field :type, type: String
  
  slug :name
end
