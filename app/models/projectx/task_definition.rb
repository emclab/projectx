module Projectx
  class TaskDefinition < ActiveRecord::Base
    attr_accessible :last_updated_by_id, :name, :ranking_order, :task_desp, :task_instruction
  end
end
