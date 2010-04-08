require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

describe Ec2Metadata::Root do

  describe :[] do
    REVISIONS.each do |revision|

      describe revision do
        before do
          @rev_obj = Ec2Metadata::Revision.new("/#{revision}/")
          Ec2Metadata.should_receive(:get).with("/#{revision}/").once.
            and_return(DATA_TYPES.join("\n"))
        end

        it "should return Ec2Metadata::Base for meta_data" do
          meta_data = @rev_obj[:meta_data]
          meta_data.class.should == Ec2Metadata::Base
        end

        it "should return Ec2Metadata::Base for user_data" do
          Ec2Metadata.should_receive(:get).with("/#{revision}/user-data").once.
            and_return("#{revision}-user_data")
          user_data = @rev_obj[:user_data]
          user_data.should == "#{revision}-user_data"
        end
      end

    end
  end
  
end
