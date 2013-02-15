# This migration comes from authentify (originally 20121008012839)
class CreateSysUserRights < ActiveRecord::Migration
  def change
    create_table :authentify_sys_user_rights do |t|
      t.integer :sys_action_on_table_id
      t.integer :sys_user_group_id
      t.string :matching_column_name

      t.timestamps
    end
  end
end
