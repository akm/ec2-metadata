require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Ec2Metadata do

  describe :to_hash do
    it "root" do
      Ec2Metadata.clear_instance
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
      Ec2Metadata.to_hash.should == {
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
    end
  end

  describe :from_hash do
    it "root" do
      Ec2Metadata.clear_instance
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
          'public_keys' => [{'openssh-key' => "ssh-rsa 1234567890"}]
        }
      })
      Ec2Metadata[:user_data].should == "user-data-line1\nuser-data-line2\nuser-data-line3"
      Ec2Metadata[:ami_id].should == 'ami-abcdef01'
      Ec2Metadata['instance-id'].should == 'i-12345678'
      Ec2Metadata['public-hostname'].should == "ec2-75-101-241-136.compute-1.amazonaws.com"
      Ec2Metadata['local-hostname'].should == "ip-10-123-123-123"
      Ec2Metadata['hostname'].should == "ip-10-123-123-123"
      Ec2Metadata['local-ipv4'].should == "10.123.123.123"
      Ec2Metadata['public-ipv4'].should == "75.101.241.136"
      Ec2Metadata['public-keys']['0'].keys.should == ['openssh-key']
      Ec2Metadata['public-keys']['0']['openssh-key'].should == "ssh-rsa 1234567890"
    end
    
  end


end   
