# This migration comes from authentify (originally 20130113160225)
class AddZoneIdToAuthentifySysUserGroup < ActiveRecord::Migration
  def change
    add_column :authentify_sys_user_groups, :zone_id, :integer
  end
end
