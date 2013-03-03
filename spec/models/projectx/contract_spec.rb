require 'spec_helper'

module Projectx
  describe Contract do
    it "should be OK" do
      p = FactoryGirl.build(:contract)
      p.should be_valid
    end
    
    it "should reject nil contract amount" do
      p = FactoryGirl.build(:contract, :contract_amount => nil)
      p.should_not be_valid
    end
    
    it "should reject 0 contract amount" do
      p = FactoryGirl.build(:contract, :contract_amount => 0)
      p.should_not be_valid
    end
    
    it "should have payment term" do
      p = FactoryGirl.build(:contract, :payment_term => nil)
      p.should_not be_valid
    end
  end
end
