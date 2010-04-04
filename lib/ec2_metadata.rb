require 'net/http'

module Ec2Metadata
  DEFAULT_REV = "latest".freeze
  DEFAULT_HOST = "169.254.169.254".freeze

  autoload :Root, 'ec2_metadata/root'
  autoload :Base, 'ec2_metadata/base'
  autoload :NestableGet, 'ec2_metadata/nestable_get'

  extend Root

  def self.get(path)
    Net::HTTP.get(DEFAULT_HOST, path)
  end
end
