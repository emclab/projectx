# This migration comes from authentify (originally 20121007213401)
class CreateSysModuleMappings < ActiveRecord::Migration
  def change
    create_table :authentify_sys_module_mappings do |t|
      t.integer :sys_module_id
      t.integer :sys_user_group_id

      t.timestamps
    end
  end
end
