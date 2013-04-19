# This migration comes from customerx (originally 20130121011015)
class AddSubjectToCustomerxSalesLeads < ActiveRecord::Migration
  def change
    add_column :customerx_sales_leads, :subject, :string
  end
end
