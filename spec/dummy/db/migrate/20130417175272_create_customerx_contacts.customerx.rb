# This migration comes from customerx (originally 20130207203748)
class CreateCustomerxContacts < ActiveRecord::Migration
  def change
    create_table :customerx_contacts do |t|
      t.integer :customer_id
      t.string :name
      t.string :position
      t.string :phone
      t.string :cell_phone
      t.string :email
      t.text :brief_note

      t.timestamps
    end
  end
end
