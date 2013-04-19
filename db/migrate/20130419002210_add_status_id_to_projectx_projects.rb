class AddStatusIdToProjectxProjects < ActiveRecord::Migration
  def change
    add_column :projectx_projects, :status_id, :integer
  end
end
