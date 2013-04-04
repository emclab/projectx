# This migration comes from customerx (originally 20130131014553)
class CreateCustomerxCommRecordLogs < ActiveRecord::Migration
  def change
    create_table :customerx_comm_record_logs do |t|
      t.integer :customer_comm_record_id
      t.text :log
      t.integer :last_updated_by_id
      t.boolean :void, :default => false

      t.timestamps
    end
  end
end
