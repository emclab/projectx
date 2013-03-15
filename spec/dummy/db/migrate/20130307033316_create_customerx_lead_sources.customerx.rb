# This migration comes from customerx (originally 20130121023645)
class CreateCustomerxLeadSources < ActiveRecord::Migration
  def change
    create_table :customerx_lead_sources do |t|
      t.string :name
      t.boolean :active, :default => true
      t.integer :ranking_order
      t.integer :last_updated_by_id

      t.timestamps
    end
  end
end
