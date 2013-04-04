module Projectx
  module ProjectsHelper
    include Authentify::SessionsHelper

    def print_attribute(object, method, title = nil)
      if object.has_attribute?(method)
        return object.send(method)
      else
        return ""
      end
    end

=begin
    def has_action_right?(action, table, type)
      return session[:user_privilege].has_action_right?(action, table, type)
    end
=end

    def return_customers
      #return [] if action.blank or table_name.blank

      if !grant_access?('global_show', 'projectx_projects') && !grant_access?('regional_show', 'projectx_projects') && !grant_access?('show', 'projectx_projects')
        return []
      end
      user_zone_ids = session[:user_priviledge].user_zones
      customers = Customerx::Customer.scoped  #In Rails < 4 .all makes database call immediately, loads records and returns array.
                                              #Instead use "lazy" scoped method which returns chainable ActiveRecord::Relation object
      customers = customers.where(:zone_id => user_zone_ids) unless user_zone_ids.blank?
    end

    def sales()
      sales = ''
      if grant_access?('search_global', 'projectx_projects')
        sales = Authentify::UsersHelper.return_users('create', 'projectx_projects')
      elsif grant_access?('search_regional', 'projectx_projects')  || grant_access?('search_individual', 'projectx_projects')
        sales = Authentify::UsersHelper.return_users('create', 'projectx_projects', session[:user_priviledge].user_zones)
      end
      sales
    end

  end
end
