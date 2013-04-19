# This migration comes from customerx (originally 20130412170830)
class RemoveWhichTableFromCustomerxLogs < ActiveRecord::Migration
  def up
    remove_column :customerx_logs, :which_table
  end

  def down
    add_column :customerx_logs, :which_table, :string
  end
end
