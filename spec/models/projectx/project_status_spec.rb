require 'spec_helper'

module Projectx
  describe ProjectStatus do
    it "should be OK" do
      c = FactoryGirl.build(:project_status)
      c.should be_valid
    end
    
    it "should reject nil name" do
      c = FactoryGirl.build(:project_status, :name => nil)
      c.should_not be_valid
    end
    
    it "should reject duplicate name" do
      c1 = FactoryGirl.create(:project_status)
      c2 = FactoryGirl.build(:project_status, :brief_note => 'a dup cate name')
      c2.should_not be_valid
    end
  end
end
