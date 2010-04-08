require 'net/http'
Net::HTTP.version_1_2

module Ec2Metadata
  DEFAULT_HOST = "169.254.169.254".freeze

  autoload :HttpClient, 'ec2_metadata/http_client'
  autoload :Base, 'ec2_metadata/base'
  autoload :Root, 'ec2_metadata/root'
  autoload :Revision, 'ec2_metadata/revision'
  autoload :Dummy, 'ec2_metadata/dummy'
  autoload :Command, 'ec2_metadata/command'

  DEFAULT_REVISION = 'latest'

  extend HttpClient

  class << self
    def instance
      @instance ||= Root.new
    end

    def clear_instance
      @instance = nil
    end

    def [](key)
      instance[key]
    end

    def to_hash(revision = DEFAULT_REVISION)
      self[revision].to_hash
    end

    def from_hash(hash, revision = DEFAULT_REVISION)
      # hash = {revision => hash}
      # instance.from_hash(hash)
      rev_obj = instance.new_child(revision)
      instance.instance_variable_set(:@children, {revision => rev_obj})
      instance.instance_variable_set(:@child_keys, [revision])
      rev_obj.from_hash(hash)
    end

    def formalize_key(key)
      key.to_s.gsub(/_/, '-')
    end

    def logging(msg)
      @indent ||= 0
      disp = (" " * @indent) << msg
      # puts(disp) 
      @indent += 2
      begin
        result = yield
      ensure
        @indent -= 2
      end
      # puts "#{disp} => #{result.inspect}"
      result
    end
  end

  class NotFoundError < StandardError
  end

end

unless ENV['EC2_METADATA_DUMMY_DISABLED'] =~ /yes|true|on/i
  Ec2Metadata::Dummy.search_and_load_yaml
end
