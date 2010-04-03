require 'ec2_metadata'

module Ec2Metadata
  class Base

    attr_reader :revsion

    def initialize(revsion)
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
end
