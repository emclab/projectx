# This migration comes from customerx (originally 20130305161346)
class AddLogToCustomerxLogs < ActiveRecord::Migration
  def change
    add_column :customerx_logs, :log, :text
  end
end
