class ApplicationController < ActionController::Base
  protect_from_forgery
  include Authentify::SessionsHelper
  include Authentify::AuthentifyUtility
  include Authentify::UserPrivilegeHelper
  include Authentify::UsersHelper
end
