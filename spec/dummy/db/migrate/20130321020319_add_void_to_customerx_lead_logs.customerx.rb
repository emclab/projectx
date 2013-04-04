# This migration comes from customerx (originally 20130126043057)
class AddVoidToCustomerxLeadLogs < ActiveRecord::Migration
  def change
    add_column :customerx_lead_logs, :void, :boolean, :default => false
  end
end
