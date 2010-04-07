module Ec2Metadata
  module Dummy
    class << self
      YAML_FILENAME = 'ec2_metadata.yml'.freeze
      YAML_SEARCH_DIRS = ['./config', '.', '~', '/etc'].freeze
      ENV_SPECIFIED_PATH = "EC2_METADATA_DUMMY_YAML".freeze

      def yaml_paths
        dirs = YAML_SEARCH_DIRS.dup
        if Module.constants.include?('RAILS_ROOT')
          dirs.unshift(File.join(Module.const_get('RAILS_ROOT'), 'config'))
        end
        result = dirs.map{|d| File.join(d, YAML_FILENAME)}
        if specified_path = ENV[ENV_SPECIFIED_PATH]
          result.unshift(specified_path)
        end
        result
      end

      def search_and_load_yaml
        paths = Dir.glob(yaml_paths.map{|path| File.expand_path(path)})
        load_yaml(paths.first) unless paths.empty?
      end

      def load_yaml(path)
        erb = ERB.new(IO.read(path))
        erb.filename = path
        text = erb.result
        Ec2Metadata.from_hash(YAML.load(text))
      end
    
    end
  end
end
