# This migration comes from authentify (originally 20121007213119)
class CreateSysUserGroups < ActiveRecord::Migration
  def change
    create_table :authentify_sys_user_groups do |t|
      t.string :user_group_name
      t.string :short_note
      t.integer :user_type_code  # 1 - employee, 2 - customer, etc
      t.string :user_type_desp   #employee, customer, etc.
      #t.string :zone    #user location. ex, hq - head quarter.
        
      t.timestamps
    end
  end
end
