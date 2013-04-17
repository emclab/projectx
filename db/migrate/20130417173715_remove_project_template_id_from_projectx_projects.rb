class RemoveProjectTemplateIdFromProjectxProjects < ActiveRecord::Migration
  def up
    remove_column :projectx_projects, :project_template_id
  end

  def down
    add_column :projectx_projects, :project_template_id, :integer
  end
end
