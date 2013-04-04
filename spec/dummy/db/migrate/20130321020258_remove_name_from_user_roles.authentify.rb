# This migration comes from authentify (originally 20130320042015)
class RemoveNameFromUserRoles < ActiveRecord::Migration
  def up
    remove_column :authentify_user_roles, :name
  end

  def down
    add_column :authentify_user_roles, :name, :string
  end
end
