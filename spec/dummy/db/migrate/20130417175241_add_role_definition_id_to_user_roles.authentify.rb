# This migration comes from authentify (originally 20130320041849)
class AddRoleDefinitionIdToUserRoles < ActiveRecord::Migration
  def change
    add_column :authentify_user_roles, :role_definition_id, :integer
  end
end
