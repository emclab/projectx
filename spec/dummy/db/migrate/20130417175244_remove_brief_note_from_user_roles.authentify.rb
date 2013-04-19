# This migration comes from authentify (originally 20130320042045)
class RemoveBriefNoteFromUserRoles < ActiveRecord::Migration
  def up
    remove_column :authentify_user_roles, :brief_note
  end

  def down
    add_column :authentify_user_roles, :brief_note, :string
  end
end
