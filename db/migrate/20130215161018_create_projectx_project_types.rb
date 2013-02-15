class CreateProjectxProjectTypes < ActiveRecord::Migration
  def change
    create_table :projectx_project_types do |t|
      t.string :name
      t.integer :last_udpated_by_id
      t.boolean :active, :default => true
      t.string :brief_note

      t.timestamps
    end
  end
end
