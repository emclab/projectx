module Projectx
  class Task < ActiveRecord::Base
    attr_accessible :assigned_to_id, :brief_note, :cancelled, :completed, :expedite, :finish_date, :last_updated_by_id, :project_id, 
                    :skipped, :start_date, :status_definition_id, :task_definition_id,
                    :as => :role_new
    
    belongs_to :project, :class_name => 'Projectx::Project'
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :task_definition, :class_name => 'Projectx::TaskDefinition'
    belongs_to :status_definition, :class_name => 'Projectx::MiscDefinition'
    belongs_to :assigned_to, :class_name => 'Authentify::User'
    
    has_many :logs, :class_name => 'Projectx::Log'
    
    validates :project_id, :presence => true,
                           :numericality => {:greater_than => 0} 
    validates :task_definition_id, :presence => true,
                                   :numericality => {:greater_than => 0},
                                   :uniqueness => {:scope => :project_id, :message => '任务重复！'}
  end
end
