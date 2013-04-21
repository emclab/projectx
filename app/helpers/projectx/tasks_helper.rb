module Projectx
  module TasksHelper
   
    def return_task_definition(project_template_id)
      Projectx::TaskDefinition.where(:id => Projectx::TaskTemplate.where(:project_template_id => project_template_id).select('task_definition_id'))
    end
    
    def return_project_task_template(project_task_template_id=nil)
      if project_template_id
        Projectx::ProjectTaskTemplate.where(:id => project_task_template_id)
      else
        Projectx::ProjectTaskTemplate.order('name')
      end  
    end  
    
    def return_task_template(project_task_template_id)
      Projectx::TaskTemplate.where(:project_task_template_id => project_task_template_id).order('execution_order, execution_sub_order')
    end 
    
  end
end
