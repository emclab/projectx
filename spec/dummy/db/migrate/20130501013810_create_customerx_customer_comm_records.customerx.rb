# This migration comes from customerx (originally 20130127222547)
class CreateCustomerxCustomerCommRecords < ActiveRecord::Migration
  def change
    create_table :customerx_customer_comm_records do |t|
      t.integer :customer_id
      t.string :via
      t.string :subject
      t.text :contact_info
      t.text :content
      t.integer :last_updated_by_id
      t.integer :comm_category_id
      t.integer :reported_by_id
      t.date :comm_date
      t.boolean :void, :boolean, :default => false

      t.timestamps
    end
  end
end
