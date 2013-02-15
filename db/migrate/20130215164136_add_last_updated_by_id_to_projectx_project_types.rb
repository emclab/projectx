class AddLastUpdatedByIdToProjectxProjectTypes < ActiveRecord::Migration
  def change
    add_column :projectx_project_types, :last_updated_by_id, :integer
  end
end
