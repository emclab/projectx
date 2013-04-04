class CreateProjectxTasks < ActiveRecord::Migration
  def change
    create_table :projectx_tasks do |t|

      t.timestamps
    end
  end
end
