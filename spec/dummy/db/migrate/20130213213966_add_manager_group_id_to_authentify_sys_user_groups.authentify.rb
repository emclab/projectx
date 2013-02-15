# This migration comes from authentify (originally 20130121223922)
class AddManagerGroupIdToAuthentifySysUserGroups < ActiveRecord::Migration
  def change
    add_column :authentify_sys_user_groups, :manager_group_id, :integer
  end
end
