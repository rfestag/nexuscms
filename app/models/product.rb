class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::History::Trackable

  track_history track_create: true, track_destroy: true

  field :name, type: String
  field :price, type: Integer
  field :image, type: String
  field :quantity, type: Integer
  field :pack_size, type: Integer
  field :initial_cost, type: Float
  field :type, type: String
  field :description, type: String
  
  slug :name
end
