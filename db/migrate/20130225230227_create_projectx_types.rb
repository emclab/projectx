class CreateProjectxTypes < ActiveRecord::Migration
  def change
    create_table :projectx_types do |t|
      t.string :name
      t.string :brief_note
      t.integer :last_updated_by_id
      t.string :for_what

      t.timestamps
    end
  end
end
