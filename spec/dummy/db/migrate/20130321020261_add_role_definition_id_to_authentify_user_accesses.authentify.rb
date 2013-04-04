# This migration comes from authentify (originally 20130320042553)
class AddRoleDefinitionIdToAuthentifyUserAccesses < ActiveRecord::Migration
  def change
    add_column :authentify_user_accesses, :role_definition_id, :integer
  end
end
