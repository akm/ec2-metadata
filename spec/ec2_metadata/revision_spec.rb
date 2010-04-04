require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

describe Ec2Metadata::Root do

  describe :[] do
    REVISIONS.each do |revision|

      describe revision do
        before do
          @rev_obj = Ec2Metadata::Revision.new("/#{revision}/")
          Net::HTTP.should_receive(:get).with("169.254.169.254", "/#{revision}/").once.
            and_return(DATA_TYPES.join("\n"))
        end

        it "should return Ec2Metadata::DataType for meta_data" do
          meta_data = @rev_obj[:meta_data]
          meta_data.class.should == Ec2Metadata::DataType
        end

        it "should return Ec2Metadata::DataType for user_data" do
          Net::HTTP.should_receive(:get).with("169.254.169.254", "/#{revision}/user-data").once.
            and_return("#{revision}-user_data")
          user_data = @rev_obj[:user_data]
          user_data.should == "#{revision}-user_data"
        end
      end

    end
  end
  
end
