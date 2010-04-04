require 'ec2_metadata'

module Ec2Metadata
  module Root

    def instances
      @instances ||= {}
    end

    def instance(revision = DEFAULT_REV)
      instances[revision] ||= Base.new(revision)
    end

    def [](key)
      if revisions.include?(key.to_s)
        instance(key.to_s)
      else
        instance[key]
      end
    end

    def revisions
      @revisions ||= Ec2Metadata.get("/").split(/$/).map(&:strip)
    end

    def clear_instances
      @instances = nil
    end

    def clear_revisions
      @revisions = nil
    end

  end
end
