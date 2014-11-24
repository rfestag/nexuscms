class News
  include Attachable
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::History::Trackable
  include Mongoid::Slug

  track_history track_create: true, track_destroy: true

  field :title, type: String
  field :summary, type: String
  field :content, type: String
  file :image, ImageUploader

  slug :title
end
