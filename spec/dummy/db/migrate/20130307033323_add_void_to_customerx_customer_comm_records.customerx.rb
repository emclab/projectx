# This migration comes from customerx (originally 20130130171833)
class AddVoidToCustomerxCustomerCommRecords < ActiveRecord::Migration
  def change
    add_column :customerx_customer_comm_records, :void, :boolean, :default => false
  end
end
