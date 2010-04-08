require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Ec2Metadata do

  before do
    Ec2Metadata.clear_instance
    Ec2Metadata.should_receive(:get).with("/").once.and_return(REVISIONS.join("\n"))
  end

  describe "normal usage" do
    before do
      Ec2Metadata.should_receive(:get).with("/latest/").once.and_return(DATA_TYPES.join("\n"))
    end

    describe "user-data" do
      it "should access user-data" do
        msg = "message when instance was launched"
        Ec2Metadata.should_receive(:get).with("/latest/user-data").once.and_return(msg)
        Ec2Metadata[:user_data].should == msg
      end
    end

    describe "default path /latest/meta-data/" do
      before do
        Ec2Metadata.should_receive(:get).with("/latest/meta-data/").once.and_return(ALL_ATTR_KEYS.join("\n"))
      end

      describe "should return public-hostname" do
        before do
          @public_hostname = "ec2-75-101-241-136.compute-1.amazonaws.com".freeze
          Ec2Metadata.should_receive(:get).with("/latest/meta-data/public-hostname").once.and_return(@public_hostname)
        end
        it("with underscore Symbol") {Ec2Metadata[:public_hostname].should == @public_hostname}
        it("with underscore String") {Ec2Metadata['public_hostname'].should == @public_hostname}
        it("with hyphen Symbol") {Ec2Metadata[:'public-hostname'].should == @public_hostname}
        it("with hyphen String") {Ec2Metadata['public-hostname'].should == @public_hostname}
      end

      it "should access placement data such as 'availavility zone'" do
        Ec2Metadata.should_receive(:get).with("/latest/meta-data/placement/").
          and_return("availability-zone\nanother-placement-data")
        Ec2Metadata.should_receive(:get).with("/latest/meta-data/placement/availability-zone").
          and_return("us-east-1a")
        Ec2Metadata[:placement].keys.should == ["availability-zone", "another-placement-data"]
        Ec2Metadata[:placement][:availability_zone].should == "us-east-1a"
      end

      it "should access block-device-mapping" do
        Ec2Metadata.should_receive(:get).with("/latest/meta-data/block-device-mapping/").and_return(["ami", "ephemeral0", "root", "swap"].join("\n"))
        Ec2Metadata.should_receive(:get).with("/latest/meta-data/block-device-mapping/ami").and_return("sda1")
        Ec2Metadata.should_receive(:get).with("/latest/meta-data/block-device-mapping/ephemeral0").and_return("sda2")
        Ec2Metadata.should_receive(:get).with("/latest/meta-data/block-device-mapping/root").and_return("/dev/sda1")
        Ec2Metadata.should_receive(:get).with("/latest/meta-data/block-device-mapping/swap").and_return("sda3")
        Ec2Metadata[:block_device_mapping].keys.should == ["ami", "ephemeral0", "root", "swap"]
        Ec2Metadata[:block_device_mapping][:ami].should == "sda1"
        Ec2Metadata[:block_device_mapping][:ephemeral0].should == "sda2"
        Ec2Metadata[:block_device_mapping][:root].should == "/dev/sda1"
        Ec2Metadata[:block_device_mapping][:swap].should == "sda3"
      end
      
      it "should access some public-keys" do
        Ec2Metadata.should_receive(:get).with("/latest/meta-data/public-keys/").and_return("0=keypair0\n1=keypair1")
        Ec2Metadata.should_receive(:get).with("/latest/meta-data/public-keys/0/").and_return("openssh-key")
        Ec2Metadata.should_receive(:get).with("/latest/meta-data/public-keys/0/openssh-key").and_return("ssh-rsa 1234567890")
        Ec2Metadata.should_receive(:get).with("/latest/meta-data/public-keys/1/").and_return("another-key")
        Ec2Metadata.should_receive(:get).with("/latest/meta-data/public-keys/1/another-key").and_return("xxxxxxx abcdefghij")
        Ec2Metadata[:public_keys].keys.should == ["0", '1']
        Ec2Metadata[:public_keys][0].name.should == "keypair0"
        Ec2Metadata[:public_keys][0].keys.should == ["openssh-key"]
        Ec2Metadata[:public_keys][0][:openssh_key].should == "ssh-rsa 1234567890"
        Ec2Metadata[:public_keys][1].name.should == "keypair1"
        Ec2Metadata[:public_keys][1].keys.should == ["another-key"]
        Ec2Metadata[:public_keys][1][:another_key].should == "xxxxxxx abcdefghij"
      end
      
    end
  end

  describe "revision? '2007-01-19' specified" do
    before do
      Ec2Metadata.should_receive(:get).with("/2007-01-19/").once.and_return(DATA_TYPES.join("\n"))
    end

    describe "user-data" do
      it "should access user-data" do
        msg = "message when instance was launched"
        Ec2Metadata.should_receive(:get).with("/2007-01-19/user-data").once.and_return(msg)
        Ec2Metadata['2007-01-19'][:user_data].should == msg
      end
    end

    describe "default path /2007-01-19/meta-data/" do
      before do
        Ec2Metadata.should_receive(:get).with("/2007-01-19/meta-data/").once.and_return(ALL_ATTR_KEYS.join("\n"))
      end

      describe "should return public-hostname" do
        before do
          @public_hostname = "ec2-75-101-241-136.compute-1.amazonaws.com".freeze
          Ec2Metadata.should_receive(:get).with("/2007-01-19/meta-data/public-hostname").once.and_return(@public_hostname)
        end
        it("with underscore Symbol") {Ec2Metadata['2007-01-19'][:public_hostname].should == @public_hostname}
        it("with underscore String") {Ec2Metadata['2007-01-19']['public_hostname'].should == @public_hostname}
        it("with hyphen Symbol") {Ec2Metadata['2007-01-19'][:'public-hostname'].should == @public_hostname}
        it("with hyphen String") {Ec2Metadata['2007-01-19']['public-hostname'].should == @public_hostname}
      end
    end

  end
end
