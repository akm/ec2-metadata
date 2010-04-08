require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

describe Ec2Metadata::HttpClient do

  describe :get do
    it "should return body for Net::HTTPSuccess" do
      mock_http = mock(:http)
      mock_res = mock(:http_res)
      Net::HTTP.should_receive(:new).with("169.254.169.254").and_return(mock_http)
      mock_http.should_receive(:open_timeout=).with(5)
      mock_http.should_receive(:read_timeout=).with(10)
      mock_http.should_receive(:start).and_yield(mock_http)
      mock_http.should_receive(:get).with("/path1").and_return(mock_res)
      mock_res.should_receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
      mock_res.should_receive(:body).and_return("HTTP Success Response Body1")
      Ec2Metadata.get("/path1").should == "HTTP Success Response Body1"
    end
    
    it "should return nil not for Net::HTTPSuccess" do
      mock_http = mock(:http)
      mock_res = mock(:http_res)
      Net::HTTP.should_receive(:new).with("169.254.169.254").and_return(mock_http)
      mock_http.should_receive(:open_timeout=).with(5)
      mock_http.should_receive(:read_timeout=).with(10)
      mock_http.should_receive(:start).and_yield(mock_http)
      mock_http.should_receive(:get).with("/path1").and_return(mock_res)
      mock_res.should_receive(:is_a?).with(Net::HTTPSuccess).and_return(false)
      mock_res.should_not_receive(:body) # .and_return("404 not found")
      Ec2Metadata.get("/path1").should == nil
    end
    
  end
  
end
