require 'ec2_metadata'

module Ec2Metadata
  class Revision < Base
    def initialize(path)
      @path = path
      @default_child_name = 'meta-data'
    end

    def new_child(child_name)
      logging("new_child(#{child_name.inspect})") do
        child_path = "#{path}#{child_name}"
        child_path << '/' if is_struct?(child_name)
        DataType.new(child_path)
      end
    end

    def is_struct?(child_name)
      child_name =~ /^meta-data\/?$/
    end
    
  end
end
