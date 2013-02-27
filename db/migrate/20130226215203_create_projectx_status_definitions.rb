class CreateProjectxStatusDefinitions < ActiveRecord::Migration
  def change
    create_table :projectx_status_definitions do |t|
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
