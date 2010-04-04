require 'ec2_metadata'

module Ec2Metadata
  class Root < Base
    def initialize(path = '/')
      @path = path
      @default_child_key = 'latest'
    end

    def new_child(child_key)
      logging("new_child(#{child_key.inspect})") do
        Revision.new("#{path}#{child_key}/")
      end
    end

    def is_struct?(child_key)
      true
    end
    
  end
end
