require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

describe Ec2Metadata::Root do

  before do
    Ec2Metadata.clear_instance
  end

  describe :show do
    describe "valid" do
      it "should puts sorted data" do
        revisions = %w(1.0 2009-04-04 latest)
        data_types = %w(user-data meta-data)
        attrs = %w(ami-id hostname instance-id local-hostname local-ipv4 public-hostname public-ipv4)
        Net::HTTP.should_receive(:get).with("169.254.169.254", "/").once.and_return(revisions.join("\n"))
        Net::HTTP.should_receive(:get).with("169.254.169.254", "/latest/").once.and_return(data_types.join("\n"))
        Net::HTTP.should_receive(:get).with("169.254.169.254", "/latest/user-data").once.and_return((1..3).map{|n| "user-data-line#{n}"}.join("\n"))
        Net::HTTP.should_receive(:get).with("169.254.169.254", "/latest/meta-data/").once.and_return(attrs.join("\n"))
        Net::HTTP.should_receive(:get).with("169.254.169.254", "/latest/meta-data/ami-id").once.and_return('ami-abcdef01')
        Net::HTTP.should_receive(:get).with("169.254.169.254", "/latest/meta-data/instance-id").once.and_return('i-12345678')
        Net::HTTP.should_receive(:get).with("169.254.169.254", "/latest/meta-data/public-hostname").once.and_return('ec2-75-101-241-136.compute-1.amazonaws.com')
        Net::HTTP.should_receive(:get).with("169.254.169.254", "/latest/meta-data/local-hostname").once.and_return('ip-10-123-123-123')
        Net::HTTP.should_receive(:get).with("169.254.169.254", "/latest/meta-data/hostname").once.and_return('ip-10-123-123-123')
        Net::HTTP.should_receive(:get).with("169.254.169.254", "/latest/meta-data/local-ipv4").once.and_return('10.123.123.123')
        Net::HTTP.should_receive(:get).with("169.254.169.254", "/latest/meta-data/public-ipv4").once.and_return('75.101.241.136')
        result = <<EOS
--- 
meta-data: 
  ami-id: ami-abcdef01
  instance-id: i-12345678
  hostname: ip-10-123-123-123
  public-hostname: ec2-75-101-241-136.compute-1.amazonaws.com
  public-ipv4: 75.101.241.136
  local-hostname: ip-10-123-123-123
  local-ipv4: 10.123.123.123
user-data: |-
  user-data-line1
  user-data-line2
  user-data-line3
EOS
        Ec2Metadata::Command.should_receive(:puts).with(result)
        Ec2Metadata::Command.show
      end

      it "should display message which means 'dummy data is used'" do
        Ec2Metadata.from_hash({
          'user-data' => "user-data-line1\nuser-data-line2\nuser-data-line3",
          'meta-data' => {
            'ami-id' => 'ami-abcdef01',
            'instance-id' => 'i-12345678',
            'public-hostname' => "ec2-75-101-241-136.compute-1.amazonaws.com",
            'local-hostname' => "ip-10-123-123-123",
            'hostname' => "ip-10-123-123-123",
            'local-ipv4' => "10.123.123.123",
            'public-ipv4' => "75.101.241.136",
            # 'public_keys' => [{'openssh-key' => "ssh-rsa 1234567890"}]
          }
        })
        Ec2Metadata::Dummy.instance_variable_set(:@loaded_yaml_path, '/path/to/ec2_metadata.yml')
        result = <<EOS
--- 
meta-data: 
  ami-id: ami-abcdef01
  instance-id: i-12345678
  hostname: ip-10-123-123-123
  public-hostname: ec2-75-101-241-136.compute-1.amazonaws.com
  public-ipv4: 75.101.241.136
  local-hostname: ip-10-123-123-123
  local-ipv4: 10.123.123.123
user-data: |-
  user-data-line1
  user-data-line2
  user-data-line3
EOS
        Ec2Metadata::Command.should_receive(:puts).with(result).once
        Ec2Metadata::Command.should_receive(:puts).with("Actually these data is based on a DUMMY yaml file: /path/to/ec2_metadata.yml").once
        Ec2Metadata::Command.show
      end
    end

    it "should raise ArgumentError for invalid api version" do
      revisions = %w(1.0 2009-04-04 latest)
      Net::HTTP.should_receive(:get).with("169.254.169.254", "/").once.and_return(revisions.join("\n"))
      lambda{ 
        Ec2Metadata::Command.show("invalid api version")
      }.should raise_error(ArgumentError)
    end

  end

  describe :show_api_versions do
    it "default" do
      revisions = %w(1.0 2009-04-04 latest)
      Net::HTTP.should_receive(:get).with("169.254.169.254", "/").once.and_return(revisions.join("\n"))
      Ec2Metadata::Command.should_receive(:puts).with(revisions)
      Ec2Metadata::Command.show_api_versions
    end

  end
  
end
