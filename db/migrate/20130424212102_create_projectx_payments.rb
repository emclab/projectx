class CreateProjectxPayments < ActiveRecord::Migration
  def change
    create_table :projectx_payments do |t|
      t.integer :contract_id
      t.decimal :paid_amount, :precision => 10, :scale => 2
      t.date :received_date
      t.integer :received_by_id
      t.integer :paid_by_id
      t.string :payment_type
      t.integer :last_updated_by_id
      t.timestamps
    end
  end
end
