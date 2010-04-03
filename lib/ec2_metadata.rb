require 'net/http'

class Ec2Metadata
  DEFAULT_REV = "latest".freeze
  DEFAULT_HOST = "169.254.169.254".freeze

  class << self
    def instance(revision = DEFAULT_REV)
      @instances ||= {}
      @instances[revision] ||= self.new(revision)
    end

    def [](key)
      if revisions.include?(key.to_s)
        instance(key.to_s)
      else
        instance[key]
      end
    end

    def revisions
      @revisions ||= Net::HTTP.get(DEFAULT_HOST, "/").split(/$/).map(&:strip)
    end

    def clear_instances
      @instances = nil
    end

    def clear_revisions
      @revisions = nil
    end

  end

  attr_reader :revsion
  
  def initialize(revsion = nil)
    @revsion = revsion
  end

  def get(key)
    @data ||= {}
    path = "#{revsion}/meta-data/#{key.to_s.gsub(/_/, '-')}"
    @data[key.to_sym] ||= Net::HTTP.get(DEFAULT_HOST, path)
  end
  alias_method :[], :get

  def metadata_names
    @metadata_names ||= Net::HTTP.get(DEFAULT_HOST, "#{revsion}/meta-data/").split(/$/).map(&:strip)
  end
  
end
