class AddContractAmountToProjectxContract < ActiveRecord::Migration
  def change
    add_column :projectx_contracts, :contract_amount, :decimal, :precision => 10, :scale => 2
  end
end
