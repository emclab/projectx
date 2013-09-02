include Commonx::CommonxHelper


#if Rails.env.production?
  SUBURI = ''
  #set session timeout minutes
  SESSION_TIMEOUT_MINUTES = 90
  SESSION_WIPEOUT_HOURS = 12


# twitter buttons class
mini_btn = 'btn btn-mini '

BUTTONS_CLS = {'default' => Authentify::AuthentifyUtility.find_config_const('default-btn'),
               'mini-default' => mini_btn + Authentify::AuthentifyUtility.find_config_const('default-btn').split(' ')[0],
               'action'       => Authentify::AuthentifyUtility.find_config_const('action-btn'),
               'mini-action'  => mini_btn + Authentify::AuthentifyUtility.find_config_const('action-btn').split(' ')[1],
               'info'         => Authentify::AuthentifyUtility.find_config_const('info-btn'),
               'mini-info'    => mini_btn + Authentify::AuthentifyUtility.find_config_const('info-btn').split(' ')[1],
               'success'      => Authentify::AuthentifyUtility.find_config_const('success-btn'),
               'mini-success' => Authentify::AuthentifyUtility.find_config_const('success-btn').split(' ')[1],
               'warning'      => Authentify::AuthentifyUtility.find_config_const('warning-btn'),
               'mini-warning' => mini_btn + Authentify::AuthentifyUtility.find_config_const('warning-btn').split(' ')[1],
               'danger'       => Authentify::AuthentifyUtility.find_config_const('danger-btn'),
               'mini-danger'  => mini_btn + Authentify::AuthentifyUtility.find_config_const('danger-btn').split(' ')[1],
               'inverse'      => Authentify::AuthentifyUtility.find_config_const('inverse-btn'),
               'mini-inverse' => mini_btn + Authentify::AuthentifyUtility.find_config_const('inverse-btn').split(' ')[1],
               'link'         => Authentify::AuthentifyUtility.find_config_const('link-btn'),
               'mini-link'    => mini_btn + Authentify::AuthentifyUtility.find_config_const('link-btn').split(' ')[1]
              }

SEARCH_STAT_INFO = Commonx::CommonxHelper.load_search_stats_config_const

