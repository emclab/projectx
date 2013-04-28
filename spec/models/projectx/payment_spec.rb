require 'spec_helper'

module Projectx
  describe Payment do
    it "should be OK" do
      p = FactoryGirl.build(:payment)
      p.should be_valid
    end
    
    it "should reject nil pay_amount" do
      p = FactoryGirl.build(:payment, :paid_amount => nil)
      p.should_not be_valid
    end
    
    it "should reject 0 pay amount" do
      p = FactoryGirl.build(:payment, :paid_amount => 0)
      p.should_not be_valid
    end
    
    it "should have received date" do
      p = FactoryGirl.build(:payment, :received_date => nil)
      p.should_not be_valid
    end
    
    it "should have payment type" do
      p = FactoryGirl.build(:payment, :payment_type => nil)
      p.should_not be_valid
    end
    
    it "should have contract id" do
      p = FactoryGirl.build(:payment, :contract_id => nil)
      p.should_not be_valid
    end
  end
end
