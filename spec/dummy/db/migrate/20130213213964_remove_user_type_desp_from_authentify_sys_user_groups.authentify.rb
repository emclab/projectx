# This migration comes from authentify (originally 20130121221921)
class RemoveUserTypeDespFromAuthentifySysUserGroups < ActiveRecord::Migration
  def up
    remove_column :authentify_sys_user_groups, :user_type_desp
  end

  def down
    add_column :authentify_sys_user_groups, :user_type_desp, :string
  end
end
