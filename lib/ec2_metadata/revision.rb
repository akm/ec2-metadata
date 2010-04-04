require 'ec2_metadata'

module Ec2Metadata
  class Revision < Base
    def initialize(path)
      @path = path
      @default_child_key = 'meta-data'
    end

    def new_child(child_key)
      logging("new_child(#{child_key.inspect})") do
        child_path = "#{path}#{child_key}"
        child_path << '/' if is_struct?(child_key)
        DataType.new(child_path)
      end
    end

    def is_struct?(child_key)
      child_key =~ /^meta-data\/?$/
    end
    
  end
end
