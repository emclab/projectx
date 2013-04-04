# This migration comes from authentify (originally 20130121221847)
class RemoveUserTypeCodeFromAuthentifySysUserGroups < ActiveRecord::Migration
  def up
    remove_column :authentify_sys_user_groups, :user_type_code
  end

  def down
    add_column :authentify_sys_user_groups, :user_type_code, :integer
  end
end
