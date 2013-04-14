class CreateProjectxTaskTemplates < ActiveRecord::Migration
  def change
    create_table :projectx_task_templates do |t|
      t.integer :project_template_id
      t.integer :task_definition_id
      t.integer :execution_order
      t.integer :execution_sub_order
      t.boolean :start_before_previous_completed, :default => false
      t.text :brief_note
      t.boolean :need_request, :default => false

      t.timestamps
    end
  end
end
