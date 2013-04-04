# This migration comes from customerx (originally 20130113192839)
class CreateCustomerxQualitySystems < ActiveRecord::Migration
  def change
    create_table :customerx_quality_systems do |t|
      t.string :name
      t.string :brief_note
      t.boolean :active
      t.integer :last_updated_by_id
      t.integer :ranking_order

      t.timestamps
    end
  end
end
