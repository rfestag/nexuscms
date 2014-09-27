class Page
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::History::Trackable

  field :title, type: String
  field :content, type: String
end
