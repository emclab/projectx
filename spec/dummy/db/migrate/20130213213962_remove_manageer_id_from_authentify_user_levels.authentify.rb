# This migration comes from authentify (originally 20130121221731)
class RemoveManageerIdFromAuthentifyUserLevels < ActiveRecord::Migration
  def up
    remove_column :authentify_user_levels, :manager_id
  end

  def down
    add_column :authentify_user_levels, :manager_id, :integer
  end
end
