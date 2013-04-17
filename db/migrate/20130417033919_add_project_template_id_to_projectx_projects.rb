class AddProjectTemplateIdToProjectxProjects < ActiveRecord::Migration
  def change
    add_column :projectx_projects, :project_template_id, :integer 
  end
end
