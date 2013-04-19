# This migration comes from authentify (originally 20121230161406)
class AddZoneToAuthentifySysUserGroups < ActiveRecord::Migration
  def change
    add_column :authentify_sys_user_groups, :zone, :string
  end
end
