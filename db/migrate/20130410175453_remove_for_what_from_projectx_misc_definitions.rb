class RemoveForWhatFromProjectxMiscDefinitions < ActiveRecord::Migration
  def up
    remove_column :projectx_misc_definitions, :for_what
  end

  def down
    add_column :projectx_misc_definitions, :for_what, :string
  end
end
