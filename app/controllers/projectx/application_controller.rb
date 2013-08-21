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


    def search
      @title, @model, @search_stat = Authentify::AuthentifyUtility.search(params)
    end

    def search_results
      @s_s_results_details =  Authentify::AuthentifyUtility.search_results(params, @max_pagination)
    end

    def max_pagination
      @max_pagination = find_config_const('pagination').to_i
    end

  end
end
