class CreateProjectxProjects < ActiveRecord::Migration
  def change
    create_table :projectx_projects do |t|
      t.string :name
      t.string :project_num
      t.integer :customer_id
      t.integer :project_task_template_id
      #t.integer :zone_id
      t.text :project_desp
      t.integer :sales_id
      t.date :start_date
      t.date :end_date
      t.date :delivery_date
      t.date :estimated_delivery_date
      t.text :project_instruction
      t.integer :project_manager_id
      t.boolean :cancelled, :default => false
      t.boolean :completed, :default => false
      t.integer :last_updated_by_id
      t.boolean :expedite, :default => false
      t.integer :status_id
      t.date :project_date
      t.timestamps
    end
    
    add_index :projectx_projects, :customer_id
    add_index :projectx_projects, :sales_id
    add_index :projectx_projects, :status_id
    add_index :projectx_projects, :project_manager_id
    add_index :projectx_projects, :project_task_template_id
  end
end
