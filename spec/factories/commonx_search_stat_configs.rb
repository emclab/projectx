# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
=begin
  factory :commonx_search_stat_config, :class => 'Commonx::SearchStatConfig' do
    resource_name   'projectx_payments'
    stat_function   "{:week => models.joins(:contract => :payments).all(:select => 'projectx_projects.created_at as Dates, sum(projectx_payments.paid_amount) as payments')}"
    stat_header   'Dates, Payments'
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

    time_frame  "[ t('Week'),  t('Month'),  t('Quart'), t('Year')]"
    search_results_period_limit " Proc.new { models.where('projectx_payments.created_at > ?', search_stats_max_period_year.years.ago) }"
  end
=end

  factory :commonx_search_stat_config, :class => 'Commonx::SearchStatConfig' do
    resource_name   'projectx_projects'
    stat_function   %& {:week => models.joins(:contract => :payments).all(:select => "strftime('%Y/%m/%d', projectx_projects.created_at) as Dates, sum(projectx_payments.paid_amount) as Payments", :group => "strftime('%Y/%W', projectx_projects.created_at)"),
  :month => models.joins(:contract => :payments).all(:select => "strftime('%Y/%m/%d', projectx_projects.created_at) as Dates, sum(projectx_payments.paid_amount) as Payments", :group => "strftime('%Y/%m', projectx_projects.created_at)"),
  :quart => models.joins(:contract => :payments).all(:select => "strftime('%Y/%m/%d', projectx_projects.created_at) as Dates, sum(projectx_payments.paid_amount) as Payments, 
  CASE WHEN cast(strftime('%m', projectx_projects.created_at) as integer) BETWEEN 1 AND 3 THEN 1 WHEN cast(strftime('%m', projectx_projects.created_at) as integer) BETWEEN 4 and 6 THEN 2 WHEN cast(strftime('%m', projectx_projects.created_at) as integer) BETWEEN 7 and 9 THEN 3 ELSE 4 END as quarter",  :group => "strftime('%Y', projectx_projects.created_at), quarter"),
  :year => models.joins(:contract => :payments).all(:select => "strftime('%Y/%m/%d', projectx_projects.created_at) as Dates, sum(projectx_payments.paid_amount) as Payments", :group => "strftime('%Y', projectx_projects.created_at)")
  } &
    stat_summary_function   " <%=t('Payment Total($)') %>:&nbsp;&nbsp;<%= number_with_precision(number_with_delimiter(@s_s_results_details.models.joins(:contract => :payments).sum(:paid_amount)), 
          :precision => 2) %>  <%=t('Contract Total($)') %>:&nbsp;&nbsp;<%= number_with_precision(number_with_delimiter(@s_s_results_details.models.joins(:contract).sum(:contract_amount)), :precision => 2) %> "
    labels_and_fields %& {:start_date_s => { :label => t('Start Date'), :as => :string, :input_html => {:size => 40}},
           :end_date_s => { :label => t('End Date'), :as => :string, :input_html => {:size => 40}},
            :status_s => { :label => t('Project Status'), :collection => return_misc_definitions('project_status'), :label_method => :name, :value_method => :id,
                        :include_blank => true }, 
            :project_task_template_id_s => { :label => t('Project Type'), :collection => return_project_task_templates, :label_method => :name, :value_method => :id, 
                        :include_blank => true }, 
            :keyword_s => { :label => t('Keyword')},
            :zone_id_s => { :label => t('Zone'), :collection => Authentify::Zone.where(:active => true).order('ranking_order'),
              :label_method => :zone_name, :value_method => :id, :if => has_action_right?('search', 'projectx_projects')},
            :sales_id_s => {:collection => Authentify::UsersHelper::return_users('sales', 'projectx_projects'), :label_method => :name, :value_method => :id, :prompt => t('Select Sales'),
              :label => t('Sales'), :if => has_action_right?('search', 'projectx_contracts')},
            :customer_id_s => {:collection => return_customers(), :label_method => :name, :value_method => :id, :prompt => t('Choose Customer'),
                  :label => t('Customer'), :if => has_action_right?("search", "projectx_projects") }   } &
      search_where   "{
                        :project_id_s => Proc.new { models.where('projectx_projects.id = ?', params[:project][:project_id_s])},
                        :keyword_s    => Proc.new { models.where('projectx_projects.name like ? ', '{params[:project][:keyword]}')},
                        :start_date_s => Proc.new { models.where('projectx_projects.start_date > ?', params[:project][:start_date_s])},
                        :end_date_s   => Proc.new { models.where('projectx_projects.start_date < ?', params[:project][:end_date_s])},
                        :customer_id_s  => Proc.new { models.where('projectx_projects.customer_id' => params[:project][:customer_id_s] )},
                        :expedite_s   => Proc.new { models.where('projectx_projects.expedite' => params[:project][:expedite_s])},
                        :sales_id_s   => Proc.new { models.where('projectx_projects.sales_id' => params[:project][:sales_id_s]) }
                      }"    
    time_frame  %& [['week', t('Week')],  ['month', t('Month')], ['quart',  t('Quart')], ['year', t('Year')]] &
    search_results_period_limit " Proc.new { models.where('projectx_projects.created_at > ?', search_stats_max_period_year.years.ago) }"
    search_list_form 'form_list'
    stat_header 'Dates, Payment Total'
    search_params "{}"
    search_summary_function ""
  end
=begin
  factory :contract_search_stat_config, :class => 'Commonx::SearchStatConfig' do
    resource_name   'projectx_contracts'
    stat_function   "models.joins(:contract => :payments).all(:select => 'projectx_projects.created_at as Dates, sum(projectx_payments.paid_amount) as payments', :group => 'strftime('%Y/%W', projectx_projects.created_at)')"
    include_stats   true
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



=end
end
