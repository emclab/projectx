# This migration comes from projectx (originally 20130417015952)
class CreateProjectxTasks < ActiveRecord::Migration
  def change
    create_table :projectx_tasks do |t|
      t.integer :project_id
      t.text :brief_note
      t.integer :assigned_to_id
      t.boolean :cancelled, :default => false
      t.boolean :completed, :default => false
      t.boolean :expedite, :default => false
      t.boolean :skipped, :default => false
      t.date :finish_date
      t.date :start_date
      t.integer :task_status_definition_id
      t.integer :task_template_id
      t.integer :last_updated_by_id

      t.timestamps
    end
  end
end
