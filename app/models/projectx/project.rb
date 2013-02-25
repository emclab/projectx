module Projectx
  class Project < ActiveRecord::Base
    attr_accessible :cancelled, :completed, :customer_id, :delivery_date, :end_date, :name, :project_desp, :project_instruction, :project_manager_id, :project_num, :project_type_id, :sales_id, :start_date
  end
end
