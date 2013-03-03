module Projectx
  class Contract < ActiveRecord::Base
    attr_accessible :contract_on_file, :signed, :contract_amount, :other_charge, :paid_out, :payment_term, :project_id, :sign_date, :signed_by_id, :last_updated_by_id, :as => :role_new
    attr_accessible :contract_on_file, :signed, :contract_amount, :other_charge, :paid_out, :payment_term, :project_id, :sign_date, :signed_by_id, :last_updated_by_id, :as => :role_update
    
    belongs_to :project, :class_name => 'Projectx::Project'
    belongs_to :signed_by, :class_name => 'Authentify::User'
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    
    validates :contract_amount, :presence => true,
                               :numericality => {:greater_than => 0}
    validates_presence_of :payment_term
  end
end
