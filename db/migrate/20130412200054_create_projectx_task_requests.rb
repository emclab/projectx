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
      t.integer :request_status_id

      t.timestamps
    end
    
    add_index :projectx_task_requests, :task_id
    add_index :projectx_task_requests, :requested_by_id
  end
end
