# This migration comes from authentify (originally 20120608174504)
class CreateUserLevels < ActiveRecord::Migration
  def change
    create_table :authentify_user_levels do |t|
      t.integer :user_id
      t.integer :sys_user_group_id
      #t.integer :manager_id

      t.timestamps
    end
  end
end
