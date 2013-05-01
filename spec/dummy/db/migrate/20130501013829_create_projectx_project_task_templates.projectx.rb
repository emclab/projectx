# This migration comes from projectx (originally 20130417120851)
class CreateProjectxProjectTaskTemplates < ActiveRecord::Migration
  def change
    create_table :projectx_project_task_templates do |t|
      t.string :name
      t.integer :type_definition_id
      t.integer :last_updated_by_id
      t.boolean :active, :default => true
      t.text :instruction

      t.timestamps
    end
  end
end
