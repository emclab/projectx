class AddForWhichToProjectxMiscDefinitions < ActiveRecord::Migration
  def change
    add_column :projectx_misc_definitions, :for_which, :string
  end
end
