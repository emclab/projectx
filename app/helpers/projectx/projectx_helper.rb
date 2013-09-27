module Projectx
  module ProjectxHelper
    include Authentify::SessionsHelper
    include Authentify::UserPrivilegeHelper


    def return_customers
      access_rights, model_ar_r, has_record_access = access_right_finder('index', 'customerx/customers')
      return [] if access_rights.blank?
      return model_ar_r #instance_eval(access_rights.sql_code) #.present?
    end
    
    def return_projects_by_access_right
      access_rights, model_ar_r, has_record_access = access_right_finder('index', 'projectx/projects')
      return [] if access_rights.blank?
      return model_ar_r 
    end

=begin
    def sales()
      access_rights, model, model_ar_r = access_right_finder('index', 'authentify/users')
      return [] if access_rights.blank?
      return model_ar_r #instance_eval(access_rights.sql_code) #.present?
    end
=end

    def return_task_definitions
      Projectx::TaskDefinition.where(:active => true).order('ranking_order')
    end

    def return_project_task_templates
      Projectx::ProjectTaskTemplate.where(:active => true).order('ranking_order')
    end
    
    def return_project_types
      Projectx::TypeDefinition.where(:active => true).order('ranking_order')
    end

  end
end
