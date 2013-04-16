require 'spec_helper'

module Projectx
  describe TaskTemplate do
    it "should be OK" do
      c = FactoryGirl.build(:task_template)
      c.should be_valid
    end
    
    it "should reject nil task_definition" do
      c = FactoryGirl.build(:task_template, :task_definition_id => nil)
      c.should_not be_valid
    end
    
    it "should reject duplicate task_definition id" do
      c0 = FactoryGirl.create(:task_template, :task_definition_id => 1)
      c = FactoryGirl.build(:task_template, :task_definition_id => 1)
      c.should_not be_valid
    end
    
    it "should reject nil execution_order" do
      c = FactoryGirl.build(:task_template, :execution_order => nil)
      c.should_not be_valid
    end
  end
end
