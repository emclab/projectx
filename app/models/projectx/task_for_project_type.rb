module Projectx
  class TaskForProjectType < ActiveRecord::Base
    attr_accessible :execution_order, :execution_sub_order, :last_updated_by_id, :project_type_id, :start_before_previous_completed, :task_definition_id
  end
end
