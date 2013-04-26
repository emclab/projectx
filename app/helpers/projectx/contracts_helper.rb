module Projectx
  module ContractsHelper
    include Authentify::SessionsHelper
    include Authentify::UserPrivilegeHelper

    def sales()
      access_rights, model, model_ar_r = access_right_finder('index', 'authentify/users')
      return [] if access_rights.blank?
      return instance_eval(access_rights.sql_code).present?
    end

  end
end
