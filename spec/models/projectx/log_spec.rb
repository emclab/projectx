require 'spec_helper'

module Projectx
  describe Log do
    it "should be OK" do
      c = FactoryGirl.build(:log)
      c.should be_valid
    end
    
    it "should reject more than one id" do
      c = FactoryGirl.build(:log, :project_id => 1, :task_request_id => 1)
      c.should_not be_valid
    end
    
    it "should reject more than one id" do
      c = FactoryGirl.build(:log, :project_id => 1, :task_id => 1)
      c.should_not be_valid
    end 
    
    it "should reject more than one id" do
      c = FactoryGirl.build(:log, :task_id => 1, :task_request_id => 1)
      c.should_not be_valid
    end 
  end
end
