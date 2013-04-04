# This migration comes from customerx (originally 20130115221442)
class AddWebToCustomerxCustomers < ActiveRecord::Migration
  def change
    add_column :customerx_customers, :web, :string
  end
end
