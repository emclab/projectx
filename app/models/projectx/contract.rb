module Projectx
  class Contract < ActiveRecord::Base
    attr_accessible :contract_on_file, :contract_signed, :contract_total, :other_cost, :paid_out, :payment_term, :project_id, :sign_date
  end
end
