class CreateProjectxProjectTaskTemplates < ActiveRecord::Migration
  def change
    create_table :projectx_project_task_templates do |t|
      t.string :name
      t.integer :type_definition_id
      t.integer :last_updated_by_id
      t.boolean :active, :default => true
      t.text :instruction
      t.integer :ranking_order

      t.timestamps
    end
    
    add_index :projectx_project_task_templates, :type_definition_id
    add_index :projectx_project_task_templates, :active
  end
end
