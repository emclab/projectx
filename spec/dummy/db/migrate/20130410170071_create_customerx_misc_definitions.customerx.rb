# This migration comes from customerx (originally 20130307035212)
class CreateCustomerxMiscDefinitions < ActiveRecord::Migration
  def change
    create_table :customerx_misc_definitions do |t|
      t.string :name
      t.text :brief_note
      t.boolean :active, :default => true
      t.integer :ranking_order
      t.integer :last_updated_by_id
      t.string :for_which

      t.timestamps
    end
  end
end
