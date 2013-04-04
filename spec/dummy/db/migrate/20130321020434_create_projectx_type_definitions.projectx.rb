# This migration comes from projectx (originally 20130226215043)
class CreateProjectxTypeDefinitions < ActiveRecord::Migration
  def change
    create_table :projectx_type_definitions do |t|
      t.string :name
      t.string :brief_note
      t.integer :last_updated_by_id
      t.string :for_what
      t.integer :ranking_order
      t.boolean :active, :default => true

      t.timestamps
    end
  end
end
