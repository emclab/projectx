# This migration comes from customerx (originally 20130127222854)
class CreateCustomerxCommCategories < ActiveRecord::Migration
  def change
    create_table :customerx_comm_categories do |t|
      t.string :name
      t.string :brief_note
      t.boolean :active, :default => true
      t.integer :ranking_order
      t.integer :last_updated_by_id

      t.timestamps
    end
  end
end
