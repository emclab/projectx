# This migration comes from projectx (originally 20130410164145)
class CreateProjectxMiscDefinitions < ActiveRecord::Migration
  def change
    create_table :projectx_misc_definitions do |t|
      t.string :name
      t.boolean :active, :default => true
      t.string :for_what
      t.text :brief_note
      t.integer :last_updated_by_id
      t.integer :ranking_order

      t.timestamps
    end
  end
end
