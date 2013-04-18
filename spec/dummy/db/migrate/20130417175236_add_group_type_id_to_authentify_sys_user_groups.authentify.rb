# This migration comes from authentify (originally 20130121223831)
class AddGroupTypeIdToAuthentifySysUserGroups < ActiveRecord::Migration
  def change
    add_column :authentify_sys_user_groups, :group_type_id, :integer
  end
end
