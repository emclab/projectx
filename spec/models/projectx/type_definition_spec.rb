require 'spec_helper'

module Projectx
  describe TypeDefinition do
    it "should be OK" do
      c = FactoryGirl.build(:type_definition)
      c.should be_valid
    end
    
    it "should reject nil name" do
      c = FactoryGirl.build(:type_definition, :name => nil)
      c.should_not be_valid
    end

    it "should reject duplicate name " do
      c1 = FactoryGirl.create(:type_definition)
      c2 = FactoryGirl.build(:type_definition)
      c2.should_not be_valid
    end
  end
end
