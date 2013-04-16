require 'spec_helper'

module Projectx
  describe TaskRequest do
    it "should be OK" do
      c = FactoryGirl.build(:task_request)
      c.should be_valid
    end
    
    it "should reject nil request_date" do
      c = FactoryGirl.build(:task_request, :request_date => nil)
      c.should_not be_valid
    end
    
    it "should reject nil expected_finish_date" do
      c = FactoryGirl.build(:task_request, :expected_finish_date => nil)
      c.should_not be_valid
    end
    
    it "should reject nil request_content" do
      c = FactoryGirl.build(:task_request, :request_content => nil)
      c.should_not be_valid
    end
    
    it "should reject nil task_id" do
      c = FactoryGirl.build(:task_request, :task_id => nil)
      c.should_not be_valid
    end
  end
end
