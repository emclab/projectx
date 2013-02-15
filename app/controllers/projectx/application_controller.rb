# encoding: utf-8
module Projectx
  class ApplicationController < ActionController::Base
    include Authentify::SessionsHelper
    include Authentify::AuthentifyUtility
    include Authentify::UserPrivilegeHelper
    include Authentify::UsersHelper
    
    helper_method :has_index_right?, :has_create_right?, :has_update_right?, :has_show_right?, :has_destroy_right?, :has_activate_right?, :yes_no_cn
    
    def yes_no_cn
      [['是',true ],['否', false]]
    end
  
    def has_index_right?(table_name)
      grant_access?('index', table_name)  
    end
    
    def has_show_right?(table_name)
      grant_access?('show', table_name)  
    end
    
    def has_create_right?(table_name)
      grant_access?('create', table_name)  
    end
    
    def has_update_right?(table_name)
      grant_access?('update', table_name)  
    end
    
    def has_destroy_right?(table_name)
      grant_access?('destroy', table_name)
    end
    
    #allow to activate/deactivate a customer
    def has_activate_right?(table_name)
      grant_access?('activate', table_name)
    end
  end
end
