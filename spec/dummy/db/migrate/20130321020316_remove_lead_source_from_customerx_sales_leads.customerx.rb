# This migration comes from customerx (originally 20130121024704)
class RemoveLeadSourceFromCustomerxSalesLeads < ActiveRecord::Migration
  def up
    remove_column :customerx_sales_leads, :lead_source
  end

  def down
    add_column :customerx_sales_leads, :lead_source, :string
  end
end
