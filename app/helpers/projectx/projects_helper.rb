module Projectx
  module ProjectsHelper
    include Authentify::SessionsHelper
    include Authentify::UserPrivilegeHelper


    def return_customers
      access_rights, model, model_ar_r = access_right_finder('index', 'customerx/customers')
      return [] if access_rights.blank?
      return instance_eval(access_rights.sql_code) #.present?
    end

    def sales()
      access_rights, model, model_ar_r = access_right_finder('index', 'authentify/users')
      return [] if access_rights.blank?
      return instance_eval(access_rights.sql_code) #.present?
    end
=begin
      sales = ''
      if has_action_right?('search', 'projectx_projects')
        sales = Authentify::UsersHelper.return_users('create', 'projectx_projects')
      elsif grant_access?('search_regional', 'projectx_projects')  || grant_access?('search_individual', 'projectx_projects')
        sales = Authentify::UsersHelper.return_users('create', 'projectx_projects', session[:user_priviledge].user_zones)
      end
      sales
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
