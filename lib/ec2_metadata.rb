require 'net/http'

module Ec2Metadata
  DEFAULT_REV = "latest".freeze
  DEFAULT_HOST = "169.254.169.254".freeze

  autoload :Root, 'ec2_metadata/root'
  autoload :Base, 'ec2_metadata/base'

  extend Root
end
