module Projectx
  class TaskTemplate < ActiveRecord::Base
    attr_accessible :brief_note, :execution_order, :execution_sub_order, :need_request, :project_template_id, :start_before_previous_completed, 
                    :task_definition_id,
                    :as => :role_new
    
    belongs_to :project_template, :class_name => 'Projectx::ProjectTemplate'
    belongs_to :last_updated_by, :class_name => 'Authentify::User' 
    belongs_to :task_definition, :class_name => 'Projectx::TaskDefinition'
    
    validates :execution_order, :presence => true,
                                :numericality => {:greater_than => 0}
    validates :task_definition_id, :presence => true,
                                   :numericality => {:greater_than => 0}
  end
end
