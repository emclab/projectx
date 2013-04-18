# This migration comes from projectx (originally 20130412041618)
class CreateProjectxLogs < ActiveRecord::Migration
  def change
    create_table :projectx_logs do |t|
      t.integer :task_request_id
      t.integer :project_id
      t.integer :task_id
      t.text :log
      t.integer :last_updated_by_id 

      t.timestamps
    end
  end
end
