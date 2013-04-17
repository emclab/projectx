class RemoveTypeDefinitionIdFromProjectxProjects < ActiveRecord::Migration
  def change
    remove_column :projectx_projects, :type_definition_id, :integer 
  end
end
