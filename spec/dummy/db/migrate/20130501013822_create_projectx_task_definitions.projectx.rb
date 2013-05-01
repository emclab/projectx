# This migration comes from projectx (originally 20130225195629)
class CreateProjectxTaskDefinitions < ActiveRecord::Migration
  def change
    create_table :projectx_task_definitions do |t|
      t.string :name
      t.string :task_desp
      t.text :task_instruction
      t.integer :last_updated_by_id
      t.integer :ranking_order
      t.boolean :active, :default => true

      t.timestamps
    end
  end
end
