class ApplicationController < ActionController::Base
  protect_from_forgery
  include Authentify::SessionsHelper
  include Authentify::AuthentifyUtility
  include Authentify::UserPrivilegeHelper
  include Authentify::UsersHelper
  
  before_filter :company_info


    def company_info
      @company_display_info = company_display_info()
    end

end
