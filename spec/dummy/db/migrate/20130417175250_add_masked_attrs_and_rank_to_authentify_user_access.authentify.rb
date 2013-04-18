# This migration comes from authentify (originally 20130329492627)
class AddMaskedAttrsAndRankToAuthentifyUserAccess < ActiveRecord::Migration
  def change
    add_column :authentify_user_accesses, :masked_attrs, :text
    add_column :authentify_user_accesses, :rank, :integer
  end
end
