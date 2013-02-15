class RemoveLastUdpatedByIdToProjectxProjectTypes < ActiveRecord::Migration
  def up
    remove_column :projectx_project_types, :last_udpated_by_id
  end

  def down
    add_column :projectx_project_types, :last_udpated_by_id, :integer
  end
end
