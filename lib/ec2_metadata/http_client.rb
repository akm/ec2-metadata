require 'ec2_metadata'

module Ec2Metadata
  module HttpClient
    def self.extended(obj)
      obj.open_timeout_sec ||= DEFAULT_OPEN_TIMEOUT
      obj.read_timeout_sec ||= DEFAULT_READ_TIMEOUT
      puts obj.inspect
    end

    DEFAULT_OPEN_TIMEOUT = 5
    DEFAULT_READ_TIMEOUT = 10

    attr_accessor :open_timeout_sec
    attr_accessor :read_timeout_sec
    
    def get(path)
      logging("Ec2Metadata.get(#{path.inspect})") do
        http = Net::HTTP.new(DEFAULT_HOST)
        http.open_timeout = self.open_timeout_sec
        http.read_timeout = self.read_timeout_sec
        http.start do |http|
          res = http.get(path)
          res.is_a?(Net::HTTPSuccess) ? res.body : nil
        end
      end
    end

  end
end
