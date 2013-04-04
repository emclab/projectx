# This migration comes from projectx (originally 20130225201647)
class CreateProjectxTaskForProjectTypes < ActiveRecord::Migration
  def change
    create_table :projectx_task_for_project_types do |t|
      t.integer :task_definition_id
      t.integer :project_type_id
      t.integer :last_updated_by_id
      t.integer :execution_order
      t.integer :execution_sub_order
      t.boolean :start_before_previous_completed, :default => false

      t.timestamps
    end
  end
end
