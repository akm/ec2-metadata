require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Ec2Metadata do

  describe :[] do
    before do
      Ec2Metadata.clear_instance
    end

    SIMPLE_ATTR_KEYS.each do |attr_key|
      it "(#{attr_key.gsub(/-/, '_')}) should return value of respose for http://169.254.169.254/latest/meta-data/#{attr_key}" do
        Ec2Metadata.should_receive(:get).with("/").once.and_return(REVISIONS.join("\n"))
        Ec2Metadata.should_receive(:get).with("/latest/").once.and_return(DATA_TYPES.join("\n"))
        Ec2Metadata.should_receive(:get).with("/latest/meta-data/").once.and_return(ALL_ATTR_KEYS.join("\n"))
        Ec2Metadata.should_receive(:get).with("/latest/meta-data/#{attr_key}").once.and_return("latest_#{attr_key}")
        Ec2Metadata[attr_key].should == "latest_#{attr_key}"
        Ec2Metadata[attr_key.to_sym].should == "latest_#{attr_key}"
      end
    end

    REVISIONS.each do |rev|
      describe "with revision #{rev}" do
        it "('#{rev}')[attr_key] should return value of respose for http://169.254.169.254/#{rev}/meta-data/attr_key" do
          Ec2Metadata.should_receive(:get).with("/").and_return(REVISIONS.join("\n"))
          Ec2Metadata.should_receive(:get).with("/#{rev}/").once.and_return(DATA_TYPES.join("\n"))
          Ec2Metadata.should_receive(:get).with("/#{rev}/meta-data/").once.and_return(ALL_ATTR_KEYS.join("\n"))

          SIMPLE_ATTR_KEYS.each do |attr_key|
            Ec2Metadata.should_receive(:get).with("/#{rev}/meta-data/#{attr_key}").once.and_return("#{rev}_#{attr_key}")
            Ec2Metadata[rev][attr_key].should == "#{rev}_#{attr_key}"
            Ec2Metadata[rev.to_sym][attr_key.to_sym].should == "#{rev}_#{attr_key}"
          end
        end
      end
    end

  end

  describe :get do
    it "should return body for Net::HTTPSuccess" do
      mock_http = mock(:http)
      mock_res = mock(:http_res)
      Net::HTTP.should_receive(:start).with("169.254.169.254").and_yield(mock_http)
      mock_http.should_receive(:get).with("/path1").and_return(mock_res)
      mock_res.should_receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
      mock_res.should_receive(:body).and_return("HTTP Success Response Body1")
      Ec2Metadata.get("/path1").should == "HTTP Success Response Body1"
    end
    
    it "should return nil not for Net::HTTPSuccess" do
      mock_http = mock(:http)
      mock_res = mock(:http_res)
      Net::HTTP.should_receive(:start).with("169.254.169.254").and_yield(mock_http)
      mock_http.should_receive(:get).with("/path1").and_return(mock_res)
      mock_res.should_receive(:is_a?).with(Net::HTTPSuccess).and_return(false)
      mock_res.should_not_receive(:body) # .and_return("404 not found")
      Ec2Metadata.get("/path1").should == nil
    end
    
  end
  
end
