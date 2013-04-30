class CreateProjectxContracts < ActiveRecord::Migration
  def change
    create_table :projectx_contracts do |t|
      t.integer :project_id
      t.date :contract_date
      t.decimal :contract_amount, :precision => 10, :scale => 2
      t.decimal :other_charge, :precision => 10, :scale => 2
      t.integer :payment_term
      t.text :payment_agreement
      t.boolean :paid_out, :default => false
      t.boolean :signed, :default => false
      t.date :sign_date
      t.integer :signed_by_id   #recorded by program
      t.boolean :contract_on_file, :default => false
      t.integer :last_updated_by_id

      t.timestamps
    end
  end
end
