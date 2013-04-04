# This migration comes from customerx (originally 20130207034914)
class CreateCustomerxAddresses < ActiveRecord::Migration
  def change
    create_table :customerx_addresses do |t|
      t.string :province
      t.string :city_county_district
      t.string :add_line
      t.integer :customer_id

      t.timestamps
    end
  end
end
