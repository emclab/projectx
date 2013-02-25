class CreateProjectxSkipTaskForProjects < ActiveRecord::Migration
  def change
    create_table :projectx_skip_task_for_projects do |t|
      t.integer :project_id
      t.integer :task_definition_id

      t.timestamps
    end
  end
end
