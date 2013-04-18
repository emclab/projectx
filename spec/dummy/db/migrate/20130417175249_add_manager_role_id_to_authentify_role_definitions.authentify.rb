# This migration comes from authentify (originally 20130325015426)
class AddManagerRoleIdToAuthentifyRoleDefinitions < ActiveRecord::Migration
  def change
    add_column :authentify_role_definitions, :manager_role_id, :integer
  end
end
