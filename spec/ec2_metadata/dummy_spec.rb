require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

describe Ec2Metadata::Dummy do
  describe :yaml_paths do
    it "default" do
      ENV.should_receive(:[]).with("EC2_METADATA_DUMMY_YAML").once.and_return(nil)
      original_constants = Module.constants
      Module.should_receive(:constants).once.and_return(original_constants - %w(RAILS_ROOT))
      Ec2Metadata::Dummy.yaml_paths.should == [
        './config/ec2_metadata.yml',
        './ec2_metadata.yml',
        '~/ec2_metadata.yml',
        '/etc/ec2_metadata.yml'
      ]
    end

    it "with rails" do
      ENV.should_receive(:[]).with("EC2_METADATA_DUMMY_YAML").once.and_return(nil)
      original_constants = Module.constants
      Module.should_receive(:constants).once.and_return(original_constants + %w(RAILS_ROOT))
      Module.should_receive(:const_get).with("RAILS_ROOT").once.and_return("/path/to/rails/project")
      Ec2Metadata::Dummy.yaml_paths.should == [
        '/path/to/rails/project/config/ec2_metadata.yml',
        './config/ec2_metadata.yml',
        './ec2_metadata.yml',
        '~/ec2_metadata.yml',
        '/etc/ec2_metadata.yml'
      ]
    end

    it "with specified_path" do
      ENV.should_receive(:[]).with("EC2_METADATA_DUMMY_YAML").once.and_return("/path/to/dummy/yaml")
      original_constants = Module.constants
      Module.should_receive(:constants).once.and_return(original_constants - %w(RAILS_ROOT))
      Ec2Metadata::Dummy.yaml_paths.should == [
        '/path/to/dummy/yaml',
        './config/ec2_metadata.yml',
        './ec2_metadata.yml',
        '~/ec2_metadata.yml',
        '/etc/ec2_metadata.yml'
      ]
    end
  end

  describe :search_and_load_yaml do
    it "should load_yaml if yaml exists" do
      yaml_path = "/path/to/ec2_metadata.yml"
      Ec2Metadata::Dummy.should_receive(:yaml_paths).once.and_return([yaml_path])
      Dir.should_receive(:glob).with([yaml_path]).and_return([yaml_path])
      Ec2Metadata::Dummy.should_receive(:load_yaml).with(yaml_path).once
      Ec2Metadata::Dummy.search_and_load_yaml
    end

    it "shouldn't load_yaml unless yaml exists" do
      yaml_path = "/path/to/ec2_metadata.yml"
      Ec2Metadata::Dummy.should_receive(:yaml_paths).once.and_return([yaml_path])
      Dir.should_receive(:glob).with([yaml_path]).and_return([])
      Ec2Metadata::Dummy.should_not_receive(:load_yaml)
      Ec2Metadata::Dummy.search_and_load_yaml
    end
  end

  describe :load_yaml do
    require 'yaml'
    require 'erb'
    
    it "should load by from_hash" do
      yaml = {
        'user-data' => "user-data-line1\nuser-data-line2\nuser-data-line3",
        'meta-data' => {
          'ami-id' => 'ami-abcdef01',
          'instance-id' => 'i-12345678',
          'public-hostname' => "ec2-75-101-241-136.compute-1.amazonaws.com",
          'local-hostname' => "ip-10-123-123-123",
          'hostname' => "ip-10-123-123-123",
          'local-ipv4' => "10.123.123.123",
          'public-ipv4' => "75.101.241.136"
        }
      }
      yaml_path = "/path/to/ec2_metadata.yml"
      IO.should_receive(:read).with(yaml_path).and_return(YAML.dump(yaml))
      Ec2Metadata.should_receive(:from_hash).with(yaml)
      Ec2Metadata::Dummy.load_yaml(yaml_path)
    end
  end
  
end
