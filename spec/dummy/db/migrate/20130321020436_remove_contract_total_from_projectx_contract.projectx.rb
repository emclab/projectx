# This migration comes from projectx (originally 20130228184101)
class RemoveContractTotalFromProjectxContract < ActiveRecord::Migration
  def up
    remove_column :projectx_contracts, :contract_total
  end

  def down
    add_column :projectx_contracts, :contract_total, :decimal
  end
end
