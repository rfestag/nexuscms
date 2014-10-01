class HistoryTracker
  include Mongoid::History::Tracker
  include Mongoid::Userstamp
  include Mongoid::Timestamps
end
