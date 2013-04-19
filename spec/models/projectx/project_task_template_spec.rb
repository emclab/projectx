require 'spec_helper'

module Projectx
  describe ProjectTaskTemplate do
    it "should be OK" do
      c = FactoryGirl.build(:project_task_template)
      c.should be_valid
    end
    
    it "should reject nil name" do
      c = FactoryGirl.build(:project_task_template, :name => nil)
      c.should_not be_valid
    end
    
    it "should reject nil type_definition id" do
      c = FactoryGirl.build(:project_task_template, :type_definition_id => nil)
      c.should_not be_valid
    end
    
    it "should reject duplicate name " do
      c1 = FactoryGirl.create(:project_task_template)
      c2 = FactoryGirl.build(:project_task_template, :instruction => 'a dup cate name')
      c2.should_not be_valid
    end
  end
end
