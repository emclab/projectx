class CreateProjectxPayments < ActiveRecord::Migration
  def change
    create_table :projectx_payments do |t|
      t.integer :contract_id
      t.decimal :paid_amount, :precision => 10, :scale => 2
      t.date :received_date
      t.integer :received_by_id
      t.text :payment_desc
      t.string :payment_type
      t.integer :last_updated_by_id
      t.timestamps
    end
    
    add_index :projectx_payments, :contract_id
    add_index :projectx_payments, :received_by_id
    add_index :projectx_payments, :payment_type
    add_index :projectx_payments, :received_date
  end
end
