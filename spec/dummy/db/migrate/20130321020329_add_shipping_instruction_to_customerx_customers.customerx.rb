# This migration comes from customerx (originally 20130207043554)
class AddShippingInstructionToCustomerxCustomers < ActiveRecord::Migration
  def change
    add_column :customerx_customers, :shipping_instruction, :text
  end
end
