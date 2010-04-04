require 'net/http'

module Ec2Metadata
  DEFAULT_HOST = "169.254.169.254".freeze

  autoload :NestableGet, 'ec2_metadata/nestable_get'
  autoload :Base, 'ec2_metadata/base'
  autoload :NamedBase, 'ec2_metadata/named_base'
  autoload :Root, 'ec2_metadata/root'
  autoload :Revision, 'ec2_metadata/revision'
  autoload :DataType, 'ec2_metadata/data_type'

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

    def get(path)
      logging("Ec2Metadata.get(#{path.inspect})") do
        Net::HTTP.get(DEFAULT_HOST, path)
      end
    end

    def logging(msg)
      @indent ||= 0
      if block_given?
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
      else
        puts msg
      end
    end
  end

  class NotFoundError < StandardError
  end

end
