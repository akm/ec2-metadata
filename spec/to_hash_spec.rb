require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Ec2Metadata do

  BASE_YAML_HASH = {
    'user-data' => "user-data-line1\nuser-data-line2\nuser-data-line3",
    'meta-data' => {
      'ami-id' => 'ami-abcdef01',
      'ami-launch-index' => '0',
      'ami-manifest-path' =>  'akm2000-us-west-1/dev-20100406-01.manifest.xml',
      'ancestor-ami-ids' => 'ami-c32e7f86',
      'instance-id' => 'i-12345678',
      'instance-type' => 'm1.small',
      'public-hostname' => "ec2-75-101-241-136.compute-1.amazonaws.com",
      'local-hostname' => "ip-10-123-123-123",
      'hostname' => "ip-10-123-123-123",
      'local-ipv4' => "10.123.123.123",
      'public-ipv4' => "75.101.241.136",
      'public-keys' => {
        '0' => {
          'west-dev01' => {'openssh-key' => "ssh-rsa 1234567890"}}
      },
      'block-device-mapping' => {
        "ami" => "sda1",
        "ephemeral0" => "sda2",
        "root" => "/dev/sda1",
        "swap" => "sda3"
      },
      'placement' => {
        'availability-zone' => 'us-west-1b'
      }
    }
  }


  describe :to_hash do
    it "root" do
      Ec2Metadata.clear_instance
      revisions = %w(1.0 2009-04-04 latest)
      data_types = %w(user-data meta-data)
      attrs = %w(ami-id hostname instance-id local-hostname local-ipv4 public-hostname public-ipv4 
        ami-launch-index ami-manifest-path ancestor-ami-ids
        instance-type
        public-keys/ block-device-mapping/ placement/)
      Ec2Metadata.should_receive(:get).with("/").once.and_return(revisions.join("\n"))
      Ec2Metadata.should_receive(:get).with("/latest/").once.and_return(data_types.join("\n"))
      Ec2Metadata.should_receive(:get).with("/latest/user-data").once.and_return((1..3).map{|n| "user-data-line#{n}"}.join("\n"))
      Ec2Metadata.should_receive(:get).with("/latest/meta-data/").once.and_return(attrs.join("\n"))
      Ec2Metadata.should_receive(:get).with("/latest/meta-data/ami-id").once.and_return('ami-abcdef01')
      Ec2Metadata.should_receive(:get).with("/latest/meta-data/ami-launch-index").once.and_return('0')
      Ec2Metadata.should_receive(:get).with("/latest/meta-data/ami-manifest-path").once.and_return('akm2000-us-west-1/dev-20100406-01.manifest.xml')
      Ec2Metadata.should_receive(:get).with("/latest/meta-data/ancestor-ami-ids").once.and_return('ami-c32e7f86')
      Ec2Metadata.should_receive(:get).with("/latest/meta-data/instance-id").once.and_return('i-12345678')
      Ec2Metadata.should_receive(:get).with("/latest/meta-data/instance-type").once.and_return('m1.small')
      Ec2Metadata.should_receive(:get).with("/latest/meta-data/public-hostname").once.and_return('ec2-75-101-241-136.compute-1.amazonaws.com')
      Ec2Metadata.should_receive(:get).with("/latest/meta-data/local-hostname").once.and_return('ip-10-123-123-123')
      Ec2Metadata.should_receive(:get).with("/latest/meta-data/hostname").once.and_return('ip-10-123-123-123')
      Ec2Metadata.should_receive(:get).with("/latest/meta-data/local-ipv4").once.and_return('10.123.123.123')
      Ec2Metadata.should_receive(:get).with("/latest/meta-data/public-ipv4").once.and_return('75.101.241.136')
      Ec2Metadata.should_receive(:get).with("/latest/meta-data/public-keys/").once.and_return('0=west-dev01')
      Ec2Metadata.should_receive(:get).with("/latest/meta-data/public-keys/0/").once.and_return('openssh-key')
      Ec2Metadata.should_receive(:get).with("/latest/meta-data/public-keys/0/openssh-key").once.and_return('ssh-rsa 1234567890')
      Ec2Metadata.should_receive(:get).with("/latest/meta-data/block-device-mapping/").once.and_return(%w(ami ephemeral0 root swap).join("\n"))
      Ec2Metadata.should_receive(:get).with("/latest/meta-data/block-device-mapping/ami").once.and_return("sda1")
      Ec2Metadata.should_receive(:get).with("/latest/meta-data/block-device-mapping/ephemeral0").once.and_return("sda2")
      Ec2Metadata.should_receive(:get).with("/latest/meta-data/block-device-mapping/root").once.and_return("/dev/sda1")
      Ec2Metadata.should_receive(:get).with("/latest/meta-data/block-device-mapping/swap").once.and_return("sda3")
      Ec2Metadata.should_receive(:get).with("/latest/meta-data/placement/").once.and_return('availability-zone')
      Ec2Metadata.should_receive(:get).with("/latest/meta-data/placement/availability-zone").once.and_return('us-west-1b')
      
      Ec2Metadata.to_hash.should == BASE_YAML_HASH
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
    
    it "public-keys by Hash" do
      Ec2Metadata.clear_instance
      Ec2Metadata.from_hash(BASE_YAML_HASH)
      Ec2Metadata['public-keys']['0'].keys.should == ['west-dev01']
      Ec2Metadata['public-keys']['0']['west-dev01'].keys.should == ['openssh-key']
      Ec2Metadata['public-keys']['0']['west-dev01']['openssh-key'].should == "ssh-rsa 1234567890"
      Ec2Metadata['block-device-mapping'].keys.sort.should == %w(ami ephemeral0 root swap).sort
      Ec2Metadata['block-device-mapping']['ami'].should == "sda1"
      Ec2Metadata['block-device-mapping']['ephemeral0'].should == "sda2"
      Ec2Metadata['block-device-mapping']['root'].should == "/dev/sda1"
      Ec2Metadata['block-device-mapping']['swap'].should == "sda3"
      Ec2Metadata['placement'].keys.should == ['availability-zone']
      Ec2Metadata['placement']['availability-zone'].should == 'us-west-1b'
    end

  end


end   
