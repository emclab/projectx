include Authentify::AuthentifyUtility

# twitter buttons class
BUTTONS_CLS = {'default' => Authentify::AuthentifyUtility.find_config_const('default-btn'),
               'action'  => Authentify::AuthentifyUtility.find_config_const('action-btn'),
               'info'    => Authentify::AuthentifyUtility.find_config_const('info-btn'),
               'success' => Authentify::AuthentifyUtility.find_config_const('success-btn'),
               'warning' => Authentify::AuthentifyUtility.find_config_const('warning-btn'),
               'danger'  => Authentify::AuthentifyUtility.find_config_const('danger-btn'),
               'inverse' => Authentify::AuthentifyUtility.find_config_const('inverse-btn'),
               'link'    => Authentify::AuthentifyUtility.find_config_const('link-btn')
              }


