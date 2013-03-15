# encoding: utf-8
module Projectx
  class ApplicationController < ActionController::Base
    include Authentify::SessionsHelper
    include Authentify::AuthentifyUtility
    include Authentify::UserPrivilegeHelper
    include Authentify::UsersHelper


    before_filter :check_access_right



    def check_access_right
      actionsMap = {'new' => 'create', 'edit' => 'update'}
      #here we need to use our new access control framework. For now le's re-use what we currently have
      if !checkAndUpdateParam(params['controller'].sub('/', '_'), params['action'], actionsMap)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right!")
      end
    end

    protected

    # Should use the new access control framework to update 'params' hash
    # For now let's use our current implementation it for demo
    def checkAndUpdateParam(controller, action, actionsMap)
      action = actionsMap.fetch(action, action)
      if action == 'index'
          if controller == 'projectx_projects'
              params[:project] = {}
              checked = true
              if grant_access?('index', 'projectx_projects')
                params[:project] = {}
              elsif grant_access?('index_zone', 'projectx_projects')
                params[:project][:zone_id_s] = session[:user_privilege].user_zone_ids
              elsif grant_access?('index_individual', 'projectx_projects')
                params[:project][:sales_id_s] = session[:user_id]
              else
                checked = false
              end
              return checked
          elsif controller == 'projectx_status_definitions'
              return grant_access?('create', 'projectx_status_definitions') || grant_access?('update', 'projectx_status_definitions')
          elsif controller == 'projectx_type_definitions'
              return grant_access?('index_global','projectx_type_definitions') || grant_access?('index_regional','projectx_type_definitions') || grant_access?('index','projectx_type_definitions')
          end
      elsif action == 'search' or action == 'search_results'
          return grant_access?('search_individual', controller) || grant_access?('search_regional', controller) || grant_access?('search_global', controller)
      else
        return grant_access?(action, controller)
      end
    end

  end
end
