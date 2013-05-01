# This migration comes from projectx (originally 20130414200011)
class CreateProjectxTypeDefinitions < ActiveRecord::Migration
  def change
    create_table :projectx_type_definitions do |t|
      t.string :name
      t.boolean :active, :default => true
      t.text :brief_note
      t.integer :last_updated_by_id
      t.integer :ranking_order

      t.timestamps
    end
  end
end
