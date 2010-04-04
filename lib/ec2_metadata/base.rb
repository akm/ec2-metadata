require 'ec2_metadata'

module Ec2Metadata
  class Base
    include NestableGet
    alias_method :[], :get

    def initialize(revsion)
      @path = "#{revsion}/meta-data/"
    end

  end
end
