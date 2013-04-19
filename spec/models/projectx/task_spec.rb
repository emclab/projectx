require 'spec_helper'

module Projectx
  describe Task do
    it "should be OK" do
      c = FactoryGirl.build(:task)
      c.should be_valid
    end
    
    it "should reject nil task_definition" do
      c = FactoryGirl.build(:task, :task_template_id => nil)
      c.should_not be_valid
    end
    
    it "should reject duplicate task_template id for the same project" do
      c0 = FactoryGirl.create(:task, :task_template_id => 1, :project_id => 1)
      c = FactoryGirl.build(:task, :task_template_id => 1, :project_id => 1)
      c.should_not be_valid
    end
    
    it "should reject nil project_id" do
      c = FactoryGirl.build(:task, :project_id => nil)
      c.should_not be_valid
    end
    
    it "should reject nil start_date" do
      c = FactoryGirl.build(:task, :start_date => nil)
      c.should_not be_valid
    end
    
    it "should reject nil finish_date" do
      c = FactoryGirl.build(:task, :finish_date => nil)
      c.should_not be_valid
    end
  end
end
