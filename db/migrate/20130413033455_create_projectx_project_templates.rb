class CreateProjectxProjectTemplates < ActiveRecord::Migration
  def change
    create_table :projectx_project_templates do |t|
      t.string :name
      t.integer :type_definition_id
      t.integer :last_updated_by_id
      t.boolean :active, :default => true
      t.text :instruction

      t.timestamps
    end
  end
end
