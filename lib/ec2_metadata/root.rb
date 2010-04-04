require 'ec2_metadata'

module Ec2Metadata
  class Root < Base
    def initialize(path = '/')
      @path = path
      @default_child_name = 'latest'
    end

    def new_child(child_name)
      logging("new_child(#{child_name.inspect})") do
        Revision.new("#{path}#{child_name}/")
      end
    end

    def is_struct?(child_name)
      true
    end
    
  end
end
