# This migration comes from projectx (originally 20130228184158)
class AddContractAmountToProjectxContract < ActiveRecord::Migration
  def change
    add_column :projectx_contracts, :contract_amount, :decimal, :precision => 10, :scale => 2
  end
end
