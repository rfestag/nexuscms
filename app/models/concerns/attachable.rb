module Attachable
  extend ActiveSupport::Concern

  module ClassMethods
    def file field, uploader
      @file_fields ||= []
      @file_fields << field
      mount_uploader field, uploader
      puts "Mounted #{field} to #{uploader} (#{self})"
    end
    def file_fields
      @file_fields
    end
  end
end
