# This migration comes from authentify (originally 20130320041936)
class AddUserIdToUserRoles < ActiveRecord::Migration
  def change
    add_column :authentify_user_roles, :user_id, :integer
  end
end
