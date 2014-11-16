module Searchable
  extend ActiveSupport::Concern
  
  included do
    include Mongoid::Elasticsearch
    elasticsearch!
  end
  module ClassMethods
    def search opts
      es.search(opts).results
    end
    def completion *args
      es.completion(args).results 
    end
  end
  def self.search str
    Mongoid::Elasticsearch.search(str).results
  end
end
