require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Ec2Metadata do
  
  describe :[] do
    before do
      Ec2Metadata.clear_instance
    end

# irb(main):068:0> Net::HTTP.get(DEFAULT_HOST, "/latest/dynamic/").split(/$/).map(&:strip)
# => [""]
# irb(main):069:0> Net::HTTP.get(DEFAULT_HOST, "/latest/user-data/").split(/$/).map(&:strip)
# => ["<?xml version=\"1.0\" encoding=\"iso-8859-1\"?>", "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\"", "\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">", "<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\" lang=\"en\">", "<head>", "<title>404 - Not Found</title>", "</head>", "<body>", "<h1>404 - Not Found</h1>", "</body>", "</html>", ""]
 
    ATTR_NAMES.each do |attr_name|
      it "(#{attr_name.gsub(/-/, '_')}) should return value of respose for http://169.254.169.254/latest/meta-data/#{attr_name}" do
        Net::HTTP.should_receive(:get).with("169.254.169.254", "/").once.and_return(REVISIONS.join("\n"))
        Net::HTTP.should_receive(:get).with("169.254.169.254", "/latest/").once.and_return(DATA_TYPES.join("\n"))
        Net::HTTP.should_receive(:get).with("169.254.169.254", "/latest/meta-data/").once.and_return(ATTR_NAMES.join("\n"))
        Net::HTTP.should_receive(:get).with("169.254.169.254", "/latest/meta-data/#{attr_name}").once.and_return("latest_#{attr_name}")
        Ec2Metadata[attr_name].should == "latest_#{attr_name}"
        Ec2Metadata[attr_name.to_sym].should == "latest_#{attr_name}"
      end
    end

#     it "('placement') should return object like Hash" do
#       Net::HTTP.should_receive(:get).with("169.254.169.254", "/").and_return(REVISIONS.join("\n"))
#       Net::HTTP.should_receive(:get).with("169.254.169.254", "latest/meta-data/placement/").and_return("availability-zone")
#       obj = Ec2Metadata[:placement]
#       obj.keys.should == ["availability_zone"]
#       Net::HTTP.should_receive(:get).with("169.254.169.254", "latest/meta-data/placement/availability-zone").and_return("us-east-1a")
#       obj[:availability_zone].should == "us-east-1a"
#     end

#     it "('block_device_mapping') should return object like Hash" do
#       Net::HTTP.should_receive(:get).with("169.254.169.254", "/").and_return(REVISIONS.join("\n"))
#       Net::HTTP.should_receive(:get).with("169.254.169.254", "latest/meta-data/block-device-mapping/").and_return(["ami", "ephemeral0", "root", "swap"].join("\n"))
#       obj = Ec2Metadata[:block_device_mapping]
#       obj.keys.should == ["ami", "ephemeral0", "root", "swap"]
#       Net::HTTP.should_receive(:get).with("169.254.169.254", "latest/meta-data/block-device-mapping/ami").and_return("sda1")
#       obj[:ami].should == "sda1"
#       Net::HTTP.should_receive(:get).with("169.254.169.254", "latest/meta-data/block-device-mapping/ephemeral0").and_return("sda2")
#       obj[:ephemeral0].should == "sda2"
#       Net::HTTP.should_receive(:get).with("169.254.169.254", "latest/meta-data/block-device-mapping/root").and_return("/dev/sda1")
#       obj[:root].should == "/dev/sda1"
#       Net::HTTP.should_receive(:get).with("169.254.169.254", "latest/meta-data/block-device-mapping/swap").and_return("sda3")
#       obj[:swap].should == "sda3"
#     end

#     it "('public_keys') should return object like Hash" do
#       Net::HTTP.should_receive(:get).with("169.254.169.254", "/").and_return(REVISIONS.join("\n"))
#       Net::HTTP.should_receive(:get).with("169.254.169.254", "latest/meta-data/public-keys/").and_return("0=keypair0")
#       obj = Ec2Metadata[:public_keys]
#       obj.to_s.should == "keypair0"
#       Net::HTTP.should_receive(:get).with("169.254.169.254", "latest/meta-data/public-keys/o/").and_return("openssh-key")
#       obj.attr_names.should == ["openssh-key"]
#       Net::HTTP.should_receive(:get).with("169.254.169.254", "latest/meta-data/public-keys/o/openssh-key").and_return("ssh-rsa 1234567890")
#       obj[:openssh_key].should == "ssh-rsa 1234567890"
#     end

#     REVISIONS.each do |rev|
#       describe "with revision #{rev}" do
#         it "('#{rev}')[attr_name] should return value of respose for http://169.254.169.254/#{rev}/meta-data/attr_name" do
#           Net::HTTP.should_receive(:get).with("169.254.169.254", "/").and_return(REVISIONS.join("\n"))
#           ATTR_NAMES.each do |attr_name|
#             Net::HTTP.should_receive(:get).with("169.254.169.254", "#{rev}/meta-data/#{attr_name}").and_return("#{rev}_#{attr_name}")
#             Ec2Metadata[rev][attr_name].should == "#{rev}_#{attr_name}"
#             Ec2Metadata[rev.to_sym][attr_name.to_sym].should == "#{rev}_#{attr_name}"
#           end
#         end
#       end
#     end

  end
  
end
