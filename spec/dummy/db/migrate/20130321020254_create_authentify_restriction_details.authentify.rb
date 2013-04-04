# This migration comes from authentify (originally 20130317210522)
class CreateAuthentifyRestrictionDetails < ActiveRecord::Migration
  def change
    create_table :authentify_restriction_details do |t|
      t.integer :user_access_id
      t.string :match_against
      t.string :restriction_type
      t.string :brief_note

      t.timestamps
    end
  end
end
