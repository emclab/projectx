# This migration comes from projectx (originally 20130417033832)
class RemoveTypeDefinitionIdFromProjectxProjects < ActiveRecord::Migration
  def change
    remove_column :projectx_projects, :type_definition_id, :integer 
  end
end
