module Projectx
  class Payment < ActiveRecord::Base
    attr_accessor :project_name
    attr_accessible :paid_amount, :received_by_id, :payment_desc, :received_date, :payment_type, :contract_id,
                    :last_updated_by_id, :customer_name_autocomplete, 
                    :project_name,
                    :as => :role_new

    attr_accessible :paid_amount, :received_by_id, :payment_desc, :received_date, :payment_type, :contract_id,
                    :last_updated_by_id, :customer_name_autocomplete, 
                    :project_name, 
                    :as => :role_update

    attr_accessor :project_id_s, :keyword_s, :start_date_s, :end_date_s, :customer_id_s, :payment_type_s,
                    :sales_id_s, :time_frame_s, :received_by_id_s, :zone_id_s

    attr_accessible :project_id_s, :keyword_s, :start_date_s, :end_date_s, :customer_id_s, :payment_type_s,
                    :sales_id_s, :time_frame_s, :received_by_id_s, :zone_id_s,
                    :as => :role_search_stats 
                    

    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :contract, :class_name => 'Projectx::Contract'
    belongs_to :received_by, :class_name => 'Authentify::User'


    validates :paid_amount, :presence => true,
              :numericality => {:greater_than => 0}
    validates_presence_of :received_by_id, :received_date, :payment_type, :contract_id

  end
end

