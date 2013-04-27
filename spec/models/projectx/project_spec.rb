#encoding: utf-8
require 'spec_helper'

module Projectx
  describe Project do
    it "should be OK" do
      c = FactoryGirl.build(:project)
      c.should be_valid
    end
    
    it "should reject nil project_task_template_id" do
      c = FactoryGirl.build(:project, :project_task_template_id => nil)
      c.should_not be_valid
    end
    
    it "should reject duplicate task_template id namefor the same project" do
      c0 = FactoryGirl.create(:project, :name => 'A name')
      c = FactoryGirl.build(:project, :name => 'a name')
      c.should_not be_valid
    end
    
    it "should reject nil project_date" do
      c = FactoryGirl.build(:project, :project_date => nil)
      c.should_not be_valid
    end
    
    it "should reject nil start_date" do
      c = FactoryGirl.build(:project, :start_date => nil)
      c.should_not be_valid
    end
    
    it "should reject nil sales_id" do
      c = FactoryGirl.build(:project, :sales_id => nil)
      c.should_not be_valid
    end
    
    it "should reject nil customer_id" do
      c = FactoryGirl.build(:project, :sales_id => nil)
      c.should_not be_valid
    end
    
    it "should reject nil project_manager_id" do
      c = FactoryGirl.build(:project, :project_manager_id => nil)
      c.should_not be_valid
    end
    
    it "should reject nil project_num" do
      c = FactoryGirl.build(:project, :project_num => nil)
      c.should_not be_valid
    end
    
    it "should reject nil customer_id" do
      c = FactoryGirl.build(:project, :customer_id => nil)
      c.should_not be_valid
    end
  end
end
