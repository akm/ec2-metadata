require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Ec2Metadata do
  
  describe :[] do
    before do
      Ec2Metadata.clear_instance
    end

    SIMPLE_ATTR_KEYS.each do |attr_key|
      it "(#{attr_key.gsub(/-/, '_')}) should return value of respose for http://169.254.169.254/latest/meta-data/#{attr_key}" do
        Net::HTTP.should_receive(:get).with("169.254.169.254", "/").once.and_return(REVISIONS.join("\n"))
        Net::HTTP.should_receive(:get).with("169.254.169.254", "/latest/").once.and_return(DATA_TYPES.join("\n"))
        Net::HTTP.should_receive(:get).with("169.254.169.254", "/latest/meta-data/").once.and_return(ALL_ATTR_KEYS.join("\n"))
        Net::HTTP.should_receive(:get).with("169.254.169.254", "/latest/meta-data/#{attr_key}").once.and_return("latest_#{attr_key}")
        Ec2Metadata[attr_key].should == "latest_#{attr_key}"
        Ec2Metadata[attr_key.to_sym].should == "latest_#{attr_key}"
      end
    end

    REVISIONS.each do |rev|
      describe "with revision #{rev}" do
        it "('#{rev}')[attr_key] should return value of respose for http://169.254.169.254/#{rev}/meta-data/attr_key" do
          Net::HTTP.should_receive(:get).with("169.254.169.254", "/").and_return(REVISIONS.join("\n"))
          Net::HTTP.should_receive(:get).with("169.254.169.254", "/#{rev}/").once.and_return(DATA_TYPES.join("\n"))
          Net::HTTP.should_receive(:get).with("169.254.169.254", "/#{rev}/meta-data/").once.and_return(ALL_ATTR_KEYS.join("\n"))

          SIMPLE_ATTR_KEYS.each do |attr_key|
            Net::HTTP.should_receive(:get).with("169.254.169.254", "/#{rev}/meta-data/#{attr_key}").once.and_return("#{rev}_#{attr_key}")
            Ec2Metadata[rev][attr_key].should == "#{rev}_#{attr_key}"
            Ec2Metadata[rev.to_sym][attr_key.to_sym].should == "#{rev}_#{attr_key}"
          end
        end
      end
    end

  end
  
end
