# This migration comes from customerx (originally 20130105021605)
class CreateCustomerxCustomerStatusCategories < ActiveRecord::Migration
  def change
    create_table :customerx_customer_status_categories do |t|
      t.string :cate_name
      t.string :brief_note
      t.boolean :active, :default => true
      t.integer :ranking_order
      t.integer :last_updated_by_id

      t.timestamps
    end
  end
end
