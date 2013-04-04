# This migration comes from authentify (originally 20130316154602)
class CreateAuthentifyUserAccesses < ActiveRecord::Migration
  def change
    create_table :authentify_user_accesses do |t|
      t.string :right
      t.integer :user_role_id
      t.string :action
      t.string :resource
      t.string :resource_type
      t.string :brief_note
      t.integer :last_updated_by_id

      t.timestamps
    end
  end
end
