require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

describe Ec2Metadata::DataType do

  describe :[] do

    REVISIONS.each do |revision|
      describe revision do
        before do
          
        end

        SIMPLE_ATTR_NAMES.each do |attr_name|
          it "(#{attr_name.gsub(/-/, '_').inspect}) should return #{attr_name}" do
            @meta_data = Ec2Metadata::DataType.new("/#{revision}/meta-data/")
            Net::HTTP.should_receive(:get).with("169.254.169.254", "/#{revision}/meta-data/").once.
              and_return(ALL_ATTR_NAMES.join("\n"))
            Net::HTTP.should_receive(:get).with("169.254.169.254", "/#{revision}/meta-data/#{attr_name}").once.
              and_return("#{revision}_#{attr_name}")
            @meta_data[attr_name].should == "#{revision}_#{attr_name}"
            @meta_data[attr_name.to_sym].should == "#{revision}_#{attr_name}"
          end
        end

#         it "('placement') should return object like Hash" do
#           Net::HTTP.should_receive(:get).with("169.254.169.254", "/").and_return(REVISIONS.join("\n"))
#           Net::HTTP.should_receive(:get).with("169.254.169.254", "latest/meta-data/placement/").and_return("availability-zone")
#           obj = Ec2Metadata[:placement]
#           obj.keys.should == ["availability_zone"]
#           Net::HTTP.should_receive(:get).with("169.254.169.254", "latest/meta-data/placement/availability-zone").and_return("us-east-1a")
#           obj[:availability_zone].should == "us-east-1a"
#         end

#         it "('block_device_mapping') should return object like Hash" do
#           Net::HTTP.should_receive(:get).with("169.254.169.254", "/").and_return(REVISIONS.join("\n"))
#           Net::HTTP.should_receive(:get).with("169.254.169.254", "latest/meta-data/block-device-mapping/").and_return(["ami", "ephemeral0", "root", "swap"].join("\n"))
#           obj = Ec2Metadata[:block_device_mapping]
#           obj.keys.should == ["ami", "ephemeral0", "root", "swap"]
#           Net::HTTP.should_receive(:get).with("169.254.169.254", "latest/meta-data/block-device-mapping/ami").and_return("sda1")
#           obj[:ami].should == "sda1"
#           Net::HTTP.should_receive(:get).with("169.254.169.254", "latest/meta-data/block-device-mapping/ephemeral0").and_return("sda2")
#           obj[:ephemeral0].should == "sda2"
#           Net::HTTP.should_receive(:get).with("169.254.169.254", "latest/meta-data/block-device-mapping/root").and_return("/dev/sda1")
#           obj[:root].should == "/dev/sda1"
#           Net::HTTP.should_receive(:get).with("169.254.169.254", "latest/meta-data/block-device-mapping/swap").and_return("sda3")
#           obj[:swap].should == "sda3"
#         end

#         it "('public_keys') should return object like Hash" do
#           Net::HTTP.should_receive(:get).with("169.254.169.254", "/").and_return(REVISIONS.join("\n"))
#           Net::HTTP.should_receive(:get).with("169.254.169.254", "latest/meta-data/public-keys/").and_return("0=keypair0")
#           obj = Ec2Metadata[:public_keys]
#           obj.to_s.should == "keypair0"
#           Net::HTTP.should_receive(:get).with("169.254.169.254", "latest/meta-data/public-keys/o/").and_return("openssh-key")
#           obj.attr_names.should == ["openssh-key"]
#           Net::HTTP.should_receive(:get).with("169.254.169.254", "latest/meta-data/public-keys/o/openssh-key").and_return("ssh-rsa 1234567890")
#           obj[:openssh_key].should == "ssh-rsa 1234567890"
#         end


      end
    end


  end
  
end
