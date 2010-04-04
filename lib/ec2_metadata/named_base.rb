require 'ec2_metadata'

module Ec2Metadata
  class NamedBase < Base
    attr_reader :name
    
    def initialize(name, path, default_child_key = nil)
      super(path, default_child_key)
      @name = name
    end

    def to_s
      @name
    end

  end
end
