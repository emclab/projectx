module Projectx
  class SkipTaskForProject < ActiveRecord::Base
    attr_accessible :project_id, :task_definition_id
  end
end
