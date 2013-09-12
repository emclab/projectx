# encoding: utf-8
module Projectx
  class Projectx::ApplicationController < ApplicationController
    include Authentify::SessionsHelper
    include Authentify::AuthentifyUtility
    include Authentify::UsersHelper
    include Authentify::UserPrivilegeHelper
    
    include Commonx::CommonxHelper
    include Projectx::ProjectsHelper

    helper_method :return_task_definitions  
     
    before_filter :require_signin 
    before_filter :max_pagination   
    before_filter :check_access_right
    before_filter :load_session_variable, :only => [:new, :edit]  #for parent_record_id & parent_resource in check_access_right
    after_filter :delete_session_variable, :only => [:create, :update]   #for parent_record_id & parent_resource in check_access_right


    def search
      @title, @model, @search_stat = Commonx::CommonxHelper.search(params)
      @erb_code = find_config_const(params[:controller].camelize.demodulize.singularize.downcase + '_search_view', 'projectx')
    end

    def search_results
      @s_s_results_details =  Commonx::CommonxHelper.search_results(params, @max_pagination)
      @erb_code = find_config_const('project_index_view', 'projectx')
    end

    def max_pagination
      @max_pagination = find_config_const('pagination').to_i
    end

  end
end
