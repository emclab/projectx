# This migration comes from authentify (originally 20121030155356)
class AddIndexToSysActionOnTables < ActiveRecord::Migration
  def change
    change_table :authentify_sys_action_on_tables do |t|
      t.index :action
      t.index :table_name
    end
  end
end
