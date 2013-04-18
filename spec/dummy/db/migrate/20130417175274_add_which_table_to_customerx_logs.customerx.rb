# This migration comes from customerx (originally 20130305161132)
class AddWhichTableToCustomerxLogs < ActiveRecord::Migration
  def change
    add_column :customerx_logs, :which_table, :string
  end
end
