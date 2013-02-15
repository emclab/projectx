class CreateProjectxProjectStatuses < ActiveRecord::Migration
  def change
    create_table :projectx_project_statuses do |t|
      t.string :name
      t.string :brief_note
      t.boolean :active, :default => true
      t.integer :last_updated_by_id
      t.integer :ranking_order

      t.timestamps
    end
  end
end
