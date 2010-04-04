require 'ec2_metadata'

module Ec2Metadata
  class Base

    attr_reader :path
    attr_reader :default_child_name
    
    def initialize(path, default_child_name = nil)
      @path = path
      @default_child_name = default_child_name
    end

    def children
      @children ||= {}
    end
    
    def child_names
      @child_names ||= Ec2Metadata.get("#{path}").split(/$/).map(&:strip)
    end

    def get(child_name)
      logging("#{self.class.name}.get(#{child_name.inspect})") do
        child_name = child_name.to_s.gsub(/_/, '-')
        if children.has_key?(child_name)
          result = children[child_name]
        else
          if is_child_name?(child_name)
            result = is_struct?(child_name) ?
              new_child(child_name) :
              Ec2Metadata.get("#{path}#{child_name}")
          else
            raise NotFoundError, "#{path}#{child_name} not found" unless default_child
            result = default_child.get(child_name)
          end
          children[child_name] = result
        end
        result
      end
    end
    alias_method :[], :get

    def is_child_name?(name)
      exp = /^#{name}\/?$/
      child_names.any?{|child_name| child_name =~ exp}
    end

    def is_struct?(child_name)
      child_name = child_name.to_s.gsub(/_/, '-') << '/'
      child_names.include?(child_name)
    end

    def new_child(child_name)
      Base.new("#{path}#{child_name}/")
    end

    alias_method :[], :get

    def default_child
      logging("default_child") do
        if default_child_name
          @default_child ||= get(default_child_name)
        else
          nil
        end
      end
    end
    

    private
    def logging(msg, &block)
      Ec2Metadata.logging(msg, &block)
    end

  end
end
