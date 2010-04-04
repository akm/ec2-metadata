require 'ec2_metadata'

module Ec2Metadata
  class Base

    attr_reader :path
    attr_reader :default_child_key
    
    def initialize(path, default_child_key = nil)
      @path = path
      @default_child_key = default_child_key
    end

    def children
      @children ||= {}
    end
    
    def child_keys
      unless defined?(@child_keys)
        lines = Ec2Metadata.get("#{path}").split(/$/).map(&:strip)
#         if lines.all?{|line| line =~ /^[\w]+\=.*?/}
#           @child_keys = []
#           lines.each do |line|            
#           end
#         else
#         end
        @child_keys = lines
      end
      @child_keys
    end

    def get(child_key)
      logging("#{self.class.name}.get(#{child_key.inspect})") do
        child_key = child_key.to_s.gsub(/_/, '-')
        if children.has_key?(child_key)
          result = children[child_key]
        else
          if is_child_key?(child_key)
            result = is_struct?(child_key) ?
              new_child(child_key) :
              Ec2Metadata.get("#{path}#{child_key}")
          else
            raise NotFoundError, "#{path}#{child_key} not found" unless default_child
            result = default_child.get(child_key)
          end
          children[child_key] = result
        end
        result
      end
    end
    alias_method :[], :get

    def is_child_key?(key)
      exp = /^#{key}\/?$/
      child_keys.any?{|child_key| child_key =~ exp}
    end

    def is_struct?(child_key)
      child_key = child_key.to_s.gsub(/_/, '-') << '/'
      child_keys.include?(child_key)
    end

    def new_child(child_key)
      Base.new("#{path}#{child_key}/")
    end

    alias_method :[], :get

    def default_child
      logging("default_child") do
        if default_child_key
          @default_child ||= get(default_child_key)
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
