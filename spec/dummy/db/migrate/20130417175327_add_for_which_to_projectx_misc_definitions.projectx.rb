# This migration comes from projectx (originally 20130410175539)
class AddForWhichToProjectxMiscDefinitions < ActiveRecord::Migration
  def change
    add_column :projectx_misc_definitions, :for_which, :string
  end
end
