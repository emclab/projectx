module Projectx
  class Task < ActiveRecord::Base
    attr_accessible :assigned_to_id, :brief_note, :cancelled, :completed, :end_date, :expedite, :expedite_finish_date, 
                    :last_updated_by_id, :project_id, :skipped, :start_date, :started, :task_definition_id, 
                    :task_execution_status_id


  end
end
