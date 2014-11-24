class Group
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Userstamp
  include Mongoid::History::Trackable
  include Mongoid::Slug

  track_history track_create: true, track_destroy: true

  field :name, type: String
  field :website, type: String
  field :picture, type: String
  field :description, type: String
  field :address, type: String
  field :location, type: Array
  field :hours, type: Hash
  field :enabled, type: Boolean
  field :fb_id, type: String
  field :fb_url, type: String

  slug :name
end
