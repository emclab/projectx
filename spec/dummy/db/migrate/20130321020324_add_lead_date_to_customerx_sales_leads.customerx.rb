# This migration comes from customerx (originally 20130203202758)
class AddLeadDateToCustomerxSalesLeads < ActiveRecord::Migration
  def change
    add_column :customerx_sales_leads, :lead_date, :date
  end
end
