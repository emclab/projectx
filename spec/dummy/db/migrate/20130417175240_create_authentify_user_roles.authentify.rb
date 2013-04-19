# This migration comes from authentify (originally 20130318014313)
class CreateAuthentifyUserRoles < ActiveRecord::Migration
  def change
    create_table :authentify_user_roles do |t|
      t.string :name
      t.string :brief_note
      t.integer :last_updated_by_id

      t.timestamps
    end
  end
end
