class CreateProjectxTaskExecutions < ActiveRecord::Migration
  def change
    create_table :projectx_task_executions do |t|
      t.integer :project_id
      t.integer :task_definition_id
      t.boolean :expedite, :default => false
      t.date :expedite_finish_date
      t.integer :last_updated_by_id
      t.string :brief_note
      t.boolean :skipped, :default => false
      t.boolean :completed, :default => false
      t.boolean :cancelled, :default => false
      t.boolean :trigger_next, :default => false
      t.date :start_date
      t.date :end_date
      t.integer :task_status_definition_id
      t.integer :assigned_to_id

      t.timestamps
    end
  end
end
