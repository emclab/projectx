class RemoveZoneIdFromProjectxProject < ActiveRecord::Migration
  def up
    remove_column :projectx_projects, :zone_id
  end

  def down
    add_column :projectx_projects, :zone_id, :integer
  end
end
