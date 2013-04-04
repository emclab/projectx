# This migration comes from customerx (originally 20130207021036)
class AddInitialOrderTotalToCustomerxSalesLeads < ActiveRecord::Migration
  def change
    add_column :customerx_sales_leads, :initial_order_total, :integer
  end
end
