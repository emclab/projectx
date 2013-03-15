# This migration comes from customerx (originally 20130113001247)
class CreateCustomerxCustomers < ActiveRecord::Migration
  def change
    create_table :customerx_customers do |t|
      t.string :name
      t.string :short_name
      t.date :since_date
      t.text :contact_info
      t.text :address
      t.text :shipping_address
      t.integer :zone_id
      t.integer :customer_status_category_id
      t.string :phone
      t.string :fax
      t.string :email
      t.integer :sales_id
      t.boolean :active, :default => true
      t.integer :last_updated_by_id
      t.integer :quality_system_id
      t.string :employee_num
      t.string :revenue
      t.text :customer_eval
      t.text :main_biz
      t.text :customer_taste
      t.text :note

      t.timestamps
    end
  end
end
