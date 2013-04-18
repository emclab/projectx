# This migration comes from customerx (originally 20130207042111)
class RemoveAddressFromCustomerxCustomers < ActiveRecord::Migration
  def up
    remove_column :customerx_customers, :address
  end

  def down
    add_column :customerx_customers, :address, :string
  end
end
