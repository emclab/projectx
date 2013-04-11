# This migration comes from customerx (originally 20130305034214)
class CreateCustomerxLogs < ActiveRecord::Migration
  def change
    create_table :customerx_logs do |t|
      t.integer :sales_lead_id
      t.integer :customer_comm_record_id
      t.integer :last_updated_by_id
      t.string :log

      t.timestamps
    end
  end
end
