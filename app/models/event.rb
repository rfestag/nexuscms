class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Userstamp
  include Mongoid::History::Trackable
  include Mongoid::Slug

  track_history track_create: true, track_destroy: true

  field :name, type: String
  field :start, type: Time
  field :stop, type: Time
  field :address, type: String
  field :location, type: Array
  field :description, type: String

  slug :name
end
