# This migration comes from projectx (originally 20130412200054)
class CreateProjectxTaskRequests < ActiveRecord::Migration
  def change
    create_table :projectx_task_requests do |t|
      t.string :name
      t.integer :task_id
      t.date :request_date
      t.boolean :expedite, :default => false
      t.date :expected_finish_date
      t.text :request_content
      t.boolean :need_delivery, :default => false
      t.text :what_to_deliver
      t.text :delivery_instruction
      t.integer :requested_by_id
      t.integer :last_updated_by_id
      t.boolean :completed, :default => false
      t.boolean :cancelled, :default => false

      t.timestamps
    end
  end
end
