# This migration comes from customerx (originally 20130120010904)
class CreateCustomerxLeadLogs < ActiveRecord::Migration
  def change
    create_table :customerx_lead_logs do |t|
      t.integer :sales_lead_id
      t.text :log
      t.integer :last_updated_by_id

      t.timestamps
    end
  end
end
