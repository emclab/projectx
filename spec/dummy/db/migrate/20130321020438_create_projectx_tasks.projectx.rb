# This migration comes from projectx (originally 20130320112001)
class CreateProjectxTasks < ActiveRecord::Migration
  def change
    create_table :projectx_tasks do |t|

      t.timestamps
    end
  end
end
