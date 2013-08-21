# encoding: utf-8
module Projectx
  class TaskRequest < ActiveRecord::Base
    attr_accessor :task_name, :requested_by_name
    attr_accessible :name, :request_content, :request_date, :requested_by_id, :delivery_instruction, :expected_finish_date, :expedite, 
                    :last_updated_by_id, :need_delivery, :task_id, :what_to_deliver, :cancelled, :completed, :request_status_id, :task_name,
                    :as => :role_new
    attr_accessible :name, :request_content, :request_date, :requested_by_id, :delivery_instruction, :expected_finish_date, :expedite, 
                    :last_updated_by_id, :need_delivery, :task_id, :what_to_deliver, :cancelled, :completed, :request_status_id, :task_name,
                    :requested_by_name, 
                    :as => :role_update                    
    belongs_to :task, :class_name => 'Projectx::Task'
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :requested_by, :class_name => 'Authentify::User'
    belongs_to :request_status, :class_name => 'Commonx::MiscDefinition'
    #has_many :logs, :class_name => 'Projectx::Log'
    
    validates_presence_of :request_date, :expected_finish_date
    validates :request_content, :presence => true
                                #:uniqueness => {:scope => :task_id, :case_sensitive => false}
    validates :task_id, :presence => true,
                        :numericality => {:greater_than => 0}
    validates :name, :presence => true,
                     :uniqueness => {:scope => :task_id, :case_sensitive => false}
  end
end
