class CreateProjectxLogs < ActiveRecord::Migration
  def change
    create_table :projectx_logs do |t|
      t.string :content
      t.last_updated_by_id :
      t.string :for_what

      t.timestamps
    end
  end
end
