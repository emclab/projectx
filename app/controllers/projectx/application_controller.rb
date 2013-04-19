# encoding: utf-8
module Projectx
  class ApplicationController < ActionController::Base
    include Authentify::SessionsHelper
    include Authentify::AuthentifyUtility
    include Authentify::UsersHelper
    include Authentify::UserPrivilegeHelper
    
    include Projectx::MiscDefinitionsHelper

    helper_method :has_action_right?, :print_attribute, :readonly?

    before_filter :require_signin
    before_filter :check_access_right

    protected

  end
end
