# This migration comes from customerx (originally 20130207200953)
class RemoveEmailContactInfoFromCustomerxCustomers < ActiveRecord::Migration
  def up
    remove_column :customerx_customers, :email
    remove_column :customerx_customers, :contact_info
  end

  def down
    add_column :customerx_customers, :contact_info, :text
    add_column :customerx_customers, :email, :string
  end
end
