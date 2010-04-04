require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Ec2Metadata do
  
  describe :[] do
    before do
      Ec2Metadata.clear_instance
    end

    SIMPLE_ATTR_NAMES.each do |attr_name|
      it "(#{attr_name.gsub(/-/, '_')}) should return value of respose for http://169.254.169.254/latest/meta-data/#{attr_name}" do
        Net::HTTP.should_receive(:get).with("169.254.169.254", "/").once.and_return(REVISIONS.join("\n"))
        Net::HTTP.should_receive(:get).with("169.254.169.254", "/latest/").once.and_return(DATA_TYPES.join("\n"))
        Net::HTTP.should_receive(:get).with("169.254.169.254", "/latest/meta-data/").once.and_return(ALL_ATTR_NAMES.join("\n"))
        Net::HTTP.should_receive(:get).with("169.254.169.254", "/latest/meta-data/#{attr_name}").once.and_return("latest_#{attr_name}")
        Ec2Metadata[attr_name].should == "latest_#{attr_name}"
        Ec2Metadata[attr_name.to_sym].should == "latest_#{attr_name}"
      end
    end

    REVISIONS.each do |rev|
      describe "with revision #{rev}" do
        it "('#{rev}')[attr_name] should return value of respose for http://169.254.169.254/#{rev}/meta-data/attr_name" do
          Net::HTTP.should_receive(:get).with("169.254.169.254", "/").and_return(REVISIONS.join("\n"))
          Net::HTTP.should_receive(:get).with("169.254.169.254", "/#{rev}/").once.and_return(DATA_TYPES.join("\n"))
          Net::HTTP.should_receive(:get).with("169.254.169.254", "/#{rev}/meta-data/").once.and_return(ALL_ATTR_NAMES.join("\n"))

          SIMPLE_ATTR_NAMES.each do |attr_name|
            Net::HTTP.should_receive(:get).with("169.254.169.254", "/#{rev}/meta-data/#{attr_name}").once.and_return("#{rev}_#{attr_name}")
            Ec2Metadata[rev][attr_name].should == "#{rev}_#{attr_name}"
            Ec2Metadata[rev.to_sym][attr_name.to_sym].should == "#{rev}_#{attr_name}"
          end
        end
      end
    end

  end
  
end
