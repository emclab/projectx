#encoding: utf-8
require 'spec_helper'

module Projectx
  
  describe Project do
    before(:each) do
      @project_num_time_gen = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'project_num_time_gen',
      :argument_value => ' Projectx::Project.last.nil? ? (Time.now.strftime("%Y%m%d") + "-"  + 112233.to_s + "-" + rand(100..999).to_s) :  (Time.now.strftime("%Y%m%d") + "-"  + (Projectx::Project.last.project_num.split("-")[-2].to_i + 555).to_s + "-" + rand(100..999).to_s)')
      @project_has_sales_config = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, 
                                                     :argument_name => 'project_has_sales', :argument_value => 'true')    
    end
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
