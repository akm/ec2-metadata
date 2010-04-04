require 'ec2_metadata'

module Ec2Metadata
  module NestableGet
    attr_reader :path
    
    def children
      @children ||= {}
    end
    
    def child_names
      @child_names ||= Ec2Metadata.get("#{path}").split(/$/).map(&:strip)
    end

    def get(child_name)
      child_name = child_name.to_s.gsub(/_/, '-')
      unless result = children[child_name]
        result = Ec2Metadata.get("#{path}#{child_name}")
        children[child_name] = result
      end
      result
    end
    alias_method :[], :get

  end
end
