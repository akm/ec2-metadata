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
        if lines.all?{|line| line =~ /^[\w]+\=.*?/}
          @child_keys = []
          @child_names = {}
          lines.each do |line|
            key, name = line.split(/\=/, 2)
            @child_keys << key
            @child_names[key] = name
          end
        else
          @child_keys = lines
        end
      end
      @child_keys
    end
    alias_method :keys, :child_keys

    def get(child_key)
      logging("#{self.class.name}.get(#{child_key.inspect})") do
        child_key = Ec2Metadata.formalize_key(child_key)
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
      k = Ec2Metadata.formalize_key(child_key) << '/'
      child_keys.include?(k) || (defined?(@child_names) && @child_names.keys.include?(child_key))
    end

    def new_child(child_key)
      if defined?(@child_names) && (name = @child_names[child_key])
        NamedBase.new(name, "#{path}#{child_key}/")
      else
        Base.new("#{path}#{child_key}/")
      end
    end

    alias_method :[], :get

    def default_child
      logging("default_child") do
        @default_child ||= get(default_child_key) if default_child_key
      end
    end

    def to_hash
      keys.inject({}) do |dest, key|
        key = key.sub(/\/$/, '')
        value = get(key)
        dest[key] = value.respond_to?(:to_hash) ? value.to_hash : value
        dest
      end
    end

    def from_hash(hash)
      hash = hash.inject({}){|d, (k, v)| d[Ec2Metadata.formalize_key(k)] = v; d}
      @child_keys = hash.keys
      @children = {}
      hash.each do |key, value|
        if value.is_a?(Array)
          idx = 0
          value = value.inject({}){|d, v| d[idx] = v; idx += 1; d}
        end
        if value.is_a?(Hash)
          child = new_child(key)
          @children[key] = child
          child.from_hash(value)
        else
          @children[key] = value
        end
      end
    end


    private
    def logging(msg, &block)
      Ec2Metadata.logging(msg, &block)
    end

  end
end
