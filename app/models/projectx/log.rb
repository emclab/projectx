module Projectx
  class Log < ActiveRecord::Base
    attr_accessible :last_updated_by_id, :log, :task_application_id, :task_id,
                    :as => :role_new
                    
    belongs_to :task, :class_name => 'Projectx::Task'
    belongs_to :task_request, :class_name => 'Projectx::TaskApplication'
    
    validates_presence_of :log
  end
end
