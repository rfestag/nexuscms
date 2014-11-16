class Page
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::History::Trackable
  include Mongoid::Slug
  include Mongoid::Ancestry

  track_history track_create: true, track_destroy: true
  has_ancestry

  field :title, type: String
  field :content, type: String
  field :order, type: Integer

  slug :title
end
