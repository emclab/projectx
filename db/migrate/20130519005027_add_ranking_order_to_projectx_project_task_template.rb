class AddRankingOrderToProjectxProjectTaskTemplate < ActiveRecord::Migration
  def change
    add_column :projectx_project_task_templates, :ranking_order, :integer
  end
end
