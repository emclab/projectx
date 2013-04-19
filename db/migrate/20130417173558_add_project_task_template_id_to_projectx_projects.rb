class AddProjectTaskTemplateIdToProjectxProjects < ActiveRecord::Migration
  def change
    add_column :projectx_projects, :project_task_template_id, :integer
  end
end
