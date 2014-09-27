class Event < Page
  include Mongoid::Document

  field :start, type: Time
  field :stop, type: Time
  field :address, type: String
  field :location, type: Array
end
