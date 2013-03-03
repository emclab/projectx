require 'spec_helper'

module Projectx
  describe StatusDefinition do
    it "should be OK" do
      p = FactoryGirl.build(:status_definition)
      p.should be_valid
    end
    
    it "should reject nil name" do
      p = FactoryGirl.build(:status_definition, :name => nil)
      p.should_not be_valid
    end
    
    it "should reject duplicate name" do
      p1 = FactoryGirl.create(:status_definition, :name => "nil")
      p = FactoryGirl.build(:status_definition, :name => "Nil")
      p.should_not be_valid
    end
    
    it "should reject nil for_what" do
      p = FactoryGirl.build(:status_definition, :for_what => nil)
      p.should_not be_valid
    end
    
    it "should reject nil last_updated_by_id" do
      p = FactoryGirl.build(:status_definition, :last_updated_by_id => nil)
      p.should_not be_valid
    end
    
    it "should reject 0 last_updated_by_id" do
      p = FactoryGirl.build(:status_definition, :last_updated_by_id => 0)
      p.should_not be_valid
    end
  end
end
