# encoding: utf-8
module Projectx
  class ApplicationController < ActionController::Base
    include Authentify::SessionsHelper
    include Authentify::AuthentifyUtility
    include Authentify::UsersHelper
    include Authentify::UserPrivilegeHelper

    helper_method :has_action_right?, :print_attribute, :readonly?

    before_filter :check_access_right

<<<<<<< HEAD
=======


    def check_access_right
      return false if session[:user_privilege].nil? 
      actionsMap = {'new' => 'create', 'edit' => 'update'}
      #here we need to use our new access control framework. For now le's re-use what we currently have
      if !checkAndUpdateParam(params['controller'].sub('/', '_'), params['action'], actionsMap)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right!")
      end
    end

>>>>>>> cf39089d252265f03e316d6f2953da5d549ca3e1
    protected

    def page(models)
      return models if models.blank?
      return models.page(params[:page]).per_page(30)
    end

  end
end
