require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

describe Ec2Metadata::Base do

  describe :[] do

    REVISIONS.each do |revision|
      describe revision do
        before do
          @meta_data = Ec2Metadata::Base.new("/#{revision}/meta-data/")
          Net::HTTP.should_receive(:get).with("169.254.169.254", "/#{revision}/meta-data/").once.
            and_return(ALL_ATTR_KEYS.join("\n"))
        end

        SIMPLE_ATTR_KEYS.each do |attr_key|
          it "(#{attr_key.gsub(/-/, '_').inspect}) should return #{attr_key}" do
            Net::HTTP.should_receive(:get).with("169.254.169.254", "/#{revision}/meta-data/#{attr_key}").once.
              and_return("#{revision}_#{attr_key}")
            @meta_data[attr_key].should == "#{revision}_#{attr_key}"
            @meta_data[attr_key.to_sym].should == "#{revision}_#{attr_key}"
          end
        end

        it "('placement') should return object like Hash" do
          Net::HTTP.should_receive(:get).with("169.254.169.254", "/#{revision}/meta-data/placement/").and_return("availability-zone")
          obj = @meta_data[:placement]
          obj.child_keys.should == ["availability-zone"]
          Net::HTTP.should_receive(:get).with("169.254.169.254", "/#{revision}/meta-data/placement/availability-zone").and_return("us-east-1a")
          obj[:availability_zone].should == "us-east-1a"
        end

        it "('block_device_mapping') should return object like Hash" do
          Net::HTTP.should_receive(:get).with("169.254.169.254", "/#{revision}/meta-data/block-device-mapping/").and_return(["ami", "ephemeral0", "root", "swap"].join("\n"))
          obj = @meta_data[:block_device_mapping]
          obj.child_keys.should == ["ami", "ephemeral0", "root", "swap"]
          Net::HTTP.should_receive(:get).with("169.254.169.254", "/#{revision}/meta-data/block-device-mapping/ami").and_return("sda1")
          obj[:ami].should == "sda1"
          Net::HTTP.should_receive(:get).with("169.254.169.254", "/#{revision}/meta-data/block-device-mapping/ephemeral0").and_return("sda2")
          obj[:ephemeral0].should == "sda2"
          Net::HTTP.should_receive(:get).with("169.254.169.254", "/#{revision}/meta-data/block-device-mapping/root").and_return("/dev/sda1")
          obj[:root].should == "/dev/sda1"
          Net::HTTP.should_receive(:get).with("169.254.169.254", "/#{revision}/meta-data/block-device-mapping/swap").and_return("sda3")
          obj[:swap].should == "sda3"
        end

        it "('public_keys') should return object like Hash" do
          Net::HTTP.should_receive(:get).with("169.254.169.254", "/#{revision}/meta-data/public-keys/").and_return("0=keypair0")
          obj = @meta_data[:public_keys]
          obj.child_keys.should == ["0"]
          obj.class.should == Ec2Metadata::Base
          key0 = obj["0"]
          key0.to_s.should == "keypair0"
          Net::HTTP.should_receive(:get).with("169.254.169.254", "/#{revision}/meta-data/public-keys/0/").and_return("openssh-key")
          key0.child_keys.should == ["openssh-key"]
          Net::HTTP.should_receive(:get).with("169.254.169.254", "/#{revision}/meta-data/public-keys/0/openssh-key").and_return("ssh-rsa 1234567890")
          key0[:openssh_key].should == "ssh-rsa 1234567890"
        end

      end
    end


  end
  
end
