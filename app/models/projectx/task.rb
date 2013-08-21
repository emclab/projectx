# encoding: utf-8
module Projectx
  class Task < ActiveRecord::Base
    attr_accessor :project_name, :customer_name, :project_task_template_name, :skipped_noupdate, :cancelled_noupdate, :completed_noupdate, :expedite_noupdate
    attr_accessible :assigned_to_id, :brief_note, :cancelled, :completed, :expedite, :finish_date, :last_updated_by_id,
                    :project_id, :skipped, :start_date, :task_template_id, :task_status_definition_id,
                    :as => :role_new
    attr_accessible :assigned_to_id, :brief_note, :cancelled, :completed, :expedite, :finish_date, :last_updated_by_id,
                    :project_id, :skipped, :start_date, :task_template_id, :task_status_definition_id,
                    :as => :role_update
                    
    belongs_to :project, :class_name => 'Projectx::Project'
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :task_template, :class_name => 'Projectx::TaskTemplate'
    belongs_to :task_status_definition, :class_name => 'Commonx::MiscDefinition'
    belongs_to :assigned_to, :class_name => 'Authentify::User' 
    has_many :task_requests, :class_name => 'Projectx::TaskRequest'   
    #has_many :logs, :class_name => 'Projectx::Log'
    
    validates :project_id, :presence => true,
                           :numericality => {:greater_than => 0} 
    validates :task_template_id, :presence => true,
                                   :numericality => {:greater_than => 0},
                                   :uniqueness => {:scope => :project_id, :message => '任务重复!'}
    validates_presence_of :start_date, :finish_date
  end
end
