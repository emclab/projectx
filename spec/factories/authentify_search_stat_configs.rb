# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payment_search_stat_config, :class => 'Authentify::SearchStatConfig' do
    resource_name   'projectx_payments'
    stat_function   "models.all(:select => 'projectx_payments.created_at as Dates, sum(projectx_payments.paid_amount) as payments', :group => 'strftime('%Y/%W', projectx_payments.created_at)')"
    include_stats   false
    labels_and_fields "{
                        :contract_id_s => { :label => t('Contract Id') },
                        :payment_id_s => { :label => t('Payment Id') },
                        :received_after_date_s => { :label => t('Paymnt Received Before Date'), :as => :string, :input_html => {:size => 40}},
                        :received_before_date_s => { :label => t('Paymnt Received After Date'), :as => :string, :input_html => {:size => 40}},
                        :received_by_id_s => { :collection => sales, :label_method => :name, :value_method => :id, :prompt => t('Choose Sales'), :label => t('Received By'), :if => has_action_right?('search', 'projectx_payments')},
                        :payment_type_s => { :label => t('Payment Type') }
                      }"
    search_where   "{
                        :contract_id_s => Proc.new { models.where('projectx_contracts.id = ?', params[:payment][:contract_id_s])},
                        :payment_id_s   => Proc.new { models.where('projectx_payments.id = ?' => params[:payment][:payment_id_s]) },
                        :received_after_date_s   => Proc.new { models.where('projectx_payments.received_date >= ?' => params[:payment][:received_after_date_s]) },
                        :received_before_date_s   => Proc.new { models.where('projectx_payments.received_date <= ?' => params[:payment][:received_before_date_s]) },
                        :received_by_id_s   => Proc.new { models.where('projectx_payments.received_by_id' => params[:payment][:received_by_id_s]) },
                        :payment_type_s   => Proc.new { models.where('projectx_payments.payment_type' => params[:payment][:payment_type_s]) }
                      }"

    search_results_url "search_results_payments_path"
    search_results_period_limit " Proc.new { models.where('projectx_payments.created_at > ?', search_stats_max_period_year.years.ago) }"
  end

  factory :project_search_stat_config, :class => 'Authentify::SearchStatConfig' do
    resource_name   'projectx_projects'
    stat_function   "models.joins(:contract => :payments).all(:select => 'projectx_projects.created_at as Dates, sum(projectx_payments.paid_amount) as payments', :group => 'strftime('%Y/%W', projectx_projects.created_at)')"
    include_stats   false
    labels_and_fields "{
                        :start_date_s => { :label => t('Start Date'), :as => :string, :input_html => {:size => 40}},
                        :end_date_s => { :label => t('End Date'), :as => :string, :input_html => {:size => 40}},
                        :status_s => { :label => t('Status'), :collection => return_misc_definitions('project_status'), :label_method => :name, :value_method => :id,
                                                :include_blank => true }, 
                        :project_task_template_id_s => { :label => 'Project Type:', :collection => return_project_task_templates, :label_method => :name, :value_method => :id, 
                                                :include_blank => true }, 
                        :keyword => { :label => t('Keyword')},
                        :zone_id_s => { :label => t('Zone'), :collection => Authentify::Zone.where(:active => true).order('ranking_order'),
                                      :label_method => :zone_name, :value_method => :id, :if => has_action_right?('search', 'projectx_projects')},
                        :sales_id_s => {:collection => sales(), :label_method => :name, :value_method => :id, :prompt => t('Select Sales'),
                                      :label => t('Sales'), :if => has_action_right?('search', 'projectx_contracts')},
                        :customer_id_s => {:collection => return_customers(), :label_method => :name, :value_method => :id, :prompt => t('Choose Customer'),
                                          :label => t('Customer'), :if => has_action_right?('search', 'projectx_projects') }
                      }"
      search_where   "{
                        :project_id_s => Proc.new { models.where('projectx_projects.id = ?', params[:project][:project_id_s])},
                        :keyword    => Proc.new { models.where('projectx_projects.name like ? ', '{params[:project][:keyword]}')},
                        :start_date_s => Proc.new { models.where('projectx_projects.created_at > ?', params[:project][:start_date_s])},
                        :end_date_s   => Proc.new { models.where('projectx_projects.created_at < ?', params[:project][:end_date_s])},
                        :customer_id_s  => Proc.new { models.where('projectx_projects.customer_id' => params[:project][:customer_id_s] )},
                        :expedite_s   => Proc.new { models.where('projectx_projects.expedite' => params[:project][:expedite_s])},
                        :completion_percent_s => Proc.new { models.where('projectx_projects.completion_percent' => params[:project][:completion_percent_s])},
                        :sales_id_s   => Proc.new { models.where('projectx_projects.sales_id' => params[:project][:sales_id_s]) }
                      }"    
    search_results_url "search_results_projects_path"
    search_results_period_limit " Proc.new { models.where('projectx_projects.created_at > ?', search_stats_max_period_year.years.ago) }"
  end

  factory :contract_search_stat_config, :class => 'Authentify::SearchStatConfig' do
    resource_name   'projectx_contracts'
    stat_function   "models.joins(:contract => :payments).all(:select => 'projectx_projects.created_at as Dates, sum(projectx_payments.paid_amount) as payments', :group => 'strftime('%Y/%W', projectx_projects.created_at)')"
    include_stats   false
    labels_and_fields "{
                        :project_id_s => { :label => t('Project Id') },
                        :paid_out_s => { :label => t('Paid out') },
                        :payment_term_s => { :label => t('Payment Term') },
                        :sign_date_s => { :label => t('Signed Date'), :as => :string, :input_html => {:size => 40}},
                        :zone_id_s => { :label => t('Zone'), :collection => Authentify::Zone.where(:active => true).order('ranking_order'),
                          :label_method => :zone_name, :value_method => :id, :if => has_action_right?('search', 'projectx_contracts')},
                        :signed_s => { :label => t('Signed') },
                        :signed_by_id_s => { :label => t('Select Signer') },
                        :contract_on_file_s => { :label => t('Contract on file')}
                      }"
    search_where   "{
                        :project_id_s => Proc.new { models.where('projectx_projects.id = ?', params[:contract][:project_id_s])},
                        :paid_out_s   => Proc.new { models.where('projectx_contracts.paid_out' => params[:contract][:paid_out_s]) },
                        :payment_term_s   => Proc.new { models.where('projectx_contracts.payment_term' => params[:contract][:payment_term_s]) },
                        :sign_date_s => Proc.new { models.where('projectx_contracts.sign_date = ?', params[:contract][:sign_date_s])},
                        :zone_id_s   => Proc.new { models.joins(:project => :customer).where(:customerx_customers => {:zone_id => params[:contract][:zone_id_s]}) },
                        :signed_s   => Proc.new { models.where('projectx_contracts.signed' => params[:contract][:signed_s]) },
                        :signed_by_id_s   => Proc.new { models.where('projectx_contracts.signed_by_id' => params[:contract][:signed_by_id_s]) },
                        :contract_on_file_s   => Proc.new { models.where('projectx_contracts.contract_on_file' => params[:contract][:contract_on_file_s]) }
                      }"

    search_results_url "search_results_contracts_path"
    search_results_period_limit " Proc.new { models.where('projectx_contracts.created_at > ?', search_stats_max_period_year.years.ago) }"
  end




end
