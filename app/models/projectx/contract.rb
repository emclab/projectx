module Projectx
  class Contract < ActiveRecord::Base
    attr_accessor :project_name, :payment_percent, :payment_total, :signed_by_name, :contract_on_file_noupdate, :paid_out_noupdate,
                    :signed_noupdate
                    
    attr_accessible :contract_on_file, :signed, :contract_amount, :other_charge, :paid_out, :payment_term, :project_id,
                    :payment_agreement, :sign_date, :signed_by_id, :last_updated_by_id,
                    :project_name, :payment_percent, :payment_total, :signed_by_name, :contract_on_file_noupdate, :paid_out_noupdate,
                    :signed_noupdate,
                    :as => :role_new

    attr_accessible :contract_on_file, :signed, :contract_amount, :other_charge, :paid_out, :payment_term, :project_id,
                    :payment_agreement, :sign_date, :signed_by_id, :last_updated_by_id, 
                    :project_name, :payment_percent, :payment_total, :signed_by_name, :contract_on_file_noupdate, :paid_out_noupdate,
                    :signed_noupdate, 
                    :as => :role_update

    attr_accessor :project_id_s, :zone_id_s, :paid_out_s, :payment_term_s, :payment_agreement_s,
                  :signed_s, :signed_by_id_s, :sign_date_s, :contract_on_file_s, :search_option_s, :time_frame_s

    attr_accessible :project_id_s, :zone_id_s, :paid_out_s, :payment_term_s, :payment_agreement_s,
                  :signed_s, :signed_by_id_s, :sign_date_s, :contract_on_file_s, :time_frame_s, :search_option_s,
                  :as => :role_search_stats

    belongs_to :project, :class_name => 'Projectx::Project'
    belongs_to :signed_by, :class_name => 'Authentify::User'
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    has_many :payments, :class_name => 'Projectx::Payment'

    validates :contract_amount, :presence => true,
                                :numericality => {:greater_than => 0}

    def payment_total
      total_payment = 0
      total_payment = payments.inject(0) {|sum, pay| sum + pay.paid_amount } unless payments.blank?
      return total_payment
    end

    def payment_percent
      return (payment_total / contract_amount).round(2)
    end

  end
end
