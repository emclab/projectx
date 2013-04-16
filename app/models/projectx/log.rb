# encoding: utf-8
module Projectx
  class Log < ActiveRecord::Base
    attr_accessible :last_updated_by_id, :log, :task_request_id, :task_id, :project_id,
                    :as => :role_new
                    
    belongs_to :task, :class_name => 'Projectx::Task'
    belongs_to :task_request, :class_name => 'Projectx::TaskRequest'
    belongs_to :project, :class_name => 'Projectx::Project'
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    
    validates_presence_of :log
    validate :ids_not_be_present_at_same_time
    
    private
    def ids_not_be_present_at_same_time
      if (project_id.present? && task_id.present?) || 
         (project_id.present? && task_request_id.present?) || 
         (task_id.present? && task_request_id.present?)
        errors.add(:project_id, "Duplicate parental object!")
      end   
    end
  end
end
