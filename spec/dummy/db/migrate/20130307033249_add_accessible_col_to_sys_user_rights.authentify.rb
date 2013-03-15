# This migration comes from authentify (originally 20121030152714)
class AddAccessibleColToSysUserRights < ActiveRecord::Migration
  def change
    add_column :authentify_sys_user_rights, :accessible_col, :string
  end
end
