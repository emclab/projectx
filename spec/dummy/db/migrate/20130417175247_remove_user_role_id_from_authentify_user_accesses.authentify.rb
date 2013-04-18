# This migration comes from authentify (originally 20130320042646)
class RemoveUserRoleIdFromAuthentifyUserAccesses < ActiveRecord::Migration
  def up
    remove_column :authentify_user_accesses, :user_role_id
  end

  def down
    add_column :authentify_user_accesses, :user_role_id, :integer
  end
end
