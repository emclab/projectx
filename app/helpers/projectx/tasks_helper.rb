module Projectx
  module TasksHelper
    def return_task_definition(project_template_id)
      Projectx::TaskDefinition.where(:id => Projectx::TaskTemplate.where(:project_template_id => project_template_id).select('task_definition_id'))
    end
  end
end
