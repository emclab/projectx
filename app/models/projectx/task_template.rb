# encoding: utf-8
module Projectx
  class TaskTemplate < ActiveRecord::Base
    attr_accessible :brief_note, :execution_order, :execution_sub_order, :need_request, :project_task_template_id, :start_before_previous_completed, 
                    :task_definition_id,
                    :as => :role_new
   attr_accessible :brief_note, :execution_order, :execution_sub_order, :need_request, :project_task_template_id, :start_before_previous_completed, 
                    :task_definition_id,
                    :as => :role_update                 
    
    belongs_to :project_task_template, :class_name => 'Projectx::ProjectTaskTemplate'
    belongs_to :last_updated_by, :class_name => 'Authentify::User' 
    belongs_to :task_definition, :class_name => 'Projectx::TaskDefinition'
    
    #validates :project_task_template_id, :presence => true,
      #                                   :numericality => {:greater_than => 0, :message => '必须 > 0'}
    validates :execution_order, :presence => true,
                                :numericality => {:greater_than => 0, :message => '必须 > 0'}
    validates :task_definition_id, :presence => true,
                                   :numericality => {:greater_than => 0},
                                   :uniqueness => {:scope => :project_task_template_id, :message => '项目任务重复！'}
    
  end
end
