# This migration comes from authentify (originally 20130113160049)
class RemoveZoneFromAuthentifySysUserGroup < ActiveRecord::Migration
  def up
    remove_column :authentify_sys_user_groups, :zone
  end

  def down
    add_column :authentify_sys_user_groups, :zone, :string
  end
end
