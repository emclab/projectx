module Projectx
  module TasksHelper
    def return_task_template(project_task_template_id)
      Projectx::TaskTemplate.where(:project_task_template_id => project_task_template_id)
    end
    
  end
end
