module Projectx
  class Contract < ActiveRecord::Base
    attr_accessible :contract_on_file, :signed, :contract_amount, :other_charge, :paid_out, :payment_term, :project_id,
                    :payment_agreement, :sign_date, :signed_by_id, :last_updated_by_id, :contract_date,
                    :as => :role_new

    attr_accessible :contract_on_file, :signed, :contract_amount, :other_charge, :paid_out, :payment_term, :project_id,
                    :payment_agreement, :sign_date, :signed_by_id, :last_updated_by_id, :contract_date,
                    :contract_date_s,
                    :as => :role_update

    attr_accessor :project_id_s, :contract_date_s, :zone_id_s, :paid_out_s, :payment_term_s, :payment_agreement_s,
                  :signed_s, :signed_by_id_s, :sign_date_s, :contract_on_file_s

    attr_accessible :project_id_s, :contract_date_s, :zone_id_s, :paid_out_s, :payment_term_s, :payment_agreement_s,
                  :signed_s, :signed_by_id_s, :sign_date_s, :contract_on_file_s,
                  :as => :role_search_stats

    belongs_to :project, :class_name => 'Projectx::Project'
    belongs_to :signed_by, :class_name => 'Authentify::User'
    belongs_to :last_updated_by, :class_name => 'Authentify::User'

    has_many :payments, :class_name => 'Projectx::Payment'

    validates :contract_amount, :presence => true,
                                :numericality => {:greater_than => 0}
    validates_presence_of :payment_term

    def payment_percent
      total_payment = 0
      total_payment = payments.inject(0) {|sum, pay| sum + pay.paid_amount } unless payments.blank?
      return total_payment / contract_amount
    end

  end
end
