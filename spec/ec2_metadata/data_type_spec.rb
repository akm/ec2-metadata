require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

describe Ec2Metadata::DataType do

  describe :[] do

    REVISIONS.each do |revision|
      ATTR_NAMES.each do |attr_name|
        it "(#{attr_name.gsub(/-/, '_').inspect}) should return #{attr_name}" do
          @meta_data = Ec2Metadata::DataType.new("/#{revision}/meta-data/")
          Net::HTTP.should_receive(:get).with("169.254.169.254", "/#{revision}/meta-data/").once.
            and_return(ATTR_NAMES.join("\n"))
          Net::HTTP.should_receive(:get).with("169.254.169.254", "/#{revision}/meta-data/#{attr_name}").once.
            and_return("#{revision}_#{attr_name}")
          @meta_data[attr_name].should == "#{revision}_#{attr_name}"
          @meta_data[attr_name.to_sym].should == "#{revision}_#{attr_name}"
        end
      end
    end

  end
  
end
