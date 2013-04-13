module Projectx
  class TaskRequest < ActiveRecord::Base
    attr_accessible :request_content, :request_date, :requested_by_id, :delivery_instruction, :expected_finish_date, :expedite, 
                    :last_updated_by_id, :need_delivery, :task_id, :what_to_deliver, :cancelled, :completed,
                    :as => :role_new
    belongs_to :task, :class_name => 'Projectx::Task'
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :requested_by, :class_name => 'Authentify::User'
    has_many :logs, :class_name => 'Projectx::Log'
    
    validates_presence_of :request_date
    validates :request_content, :presence => true,
                                :uniquness => {:scope => :task_id, :case_sensitive => false}
    validates :task_id, :presence => true,
                        :numericality => {:greater_than => 0}
  end
end
