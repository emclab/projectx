# encoding: utf-8
require 'spec_helper'

describe "Integrations" do
  describe "GET /projectx_integrations" do
    mini_btn = 'btn btn-mini '
    ActionView::CompiledTemplates::BUTTONS_CLS =
        {'default' => 'btn',
         'mini-default' => mini_btn + 'btn',
         'action'       => 'btn btn-primary',
         'mini-action'  => mini_btn + 'btn btn-primary',
         'info'         => 'btn btn-info',
         'mini-info'    => mini_btn + 'btn btn-info',
         'success'      => 'btn btn-success',
         'mini-success' => mini_btn + 'btn btn-success',
         'warning'      => 'btn btn-warning',
         'mini-warning' => mini_btn + 'btn btn-warning',
         'danger'       => 'btn btn-danger',
         'mini-danger'  => mini_btn + 'btn btn-danger',
         'inverse'      => 'btn btn-inverse',
         'mini-inverse' => mini_btn + 'btn btn-inverse',
         'link'         => 'btn btn-link',
         'mini-link'    => mini_btn +  'btn btn-link'
        }
    #@project_search_stats = FactoryGirl.create(:commonx_search_stat_config)
    #Authentify::AuthentifyUtility::SEARCH_STAT_INFO = {}
    #Authentify::AuthentifyUtility::SEARCH_STAT_INFO['projectx_projects'] = @project_search_stats
    #@contract_search_stats = FactoryGirl.create(:contract_search_stat_config)
    #Authentify::AuthentifyUtility::SEARCH_STAT_INFO['projectx_contracts'] = @contract_search_stats



    before(:each) do
      stats_config = FactoryGirl.create(:commonx_search_stat_config)
      @project_num_time_gen = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'project_num_time_gen', :argument_value => ' Projectx::Project.last.nil? ? (Time.now.strftime("%Y%m%d") + "-"  + 112233.to_s + "-" + rand(100..999).to_s) :  (Time.now.strftime("%Y%m%d") + "-"  + (Projectx::Project.last.project_num.split("-")[-2].to_i + 555).to_s + "-" + rand(100..999).to_s)')
      @project_has_sales_config = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'project_has_sales', :argument_value => 'true')
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'payment_terms', :argument_value => 'Cash,Check,Visa, MasterCard')
      @payment_type = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'payment_type', :argument_value => 'Cash, Check, Coupon, Credit Card, Credit Letter')
      
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'project_log_index_view', 
                              :argument_value => Authentify::AuthentifyUtility.find_config_const('project_log_index_view', 'projectx'))
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'task_log_index_view', 
                              :argument_value => Authentify::AuthentifyUtility.find_config_const('task_log_index_view', 'projectx')) 
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'task_request_log_index_view', 
                              :argument_value => Authentify::AuthentifyUtility.find_config_const('task_request_log_index_view', 'projectx')) 
      qs = Commonx::MiscDefinition.new({:name => 'ISO9000', :for_which => 'customer_quality_system'}, :as => :role_new)
      add = FactoryGirl.create(:address)
      #cate = FactoryGirl.create(:misc_definition, :for_which => 'customer_status', :name => 'order category')
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      
      ua1 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'projectx_projects', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "Projectx::Project.scoped")
      ua1 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'projectx_projects', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'projectx_projects', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'show', :resource => 'projectx_projects', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'index_task', :resource => 'projectx_projects', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'index_payment', :resource => 'projectx_projects', :role_definition_id => @role.id, :rank => 1,
                               :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'search', :resource => 'projectx_projects', :role_definition_id => @role.id, :rank => 1,
                               :sql_code => "")
      ua2 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'projectx_tasks', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "Projectx::Task.scoped")
      ua2 = FactoryGirl.create(:user_access, :action => 'show_log_new', :resource => 'projectx_tasks', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua3 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'projectx_tasks', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua31 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'projectx_tasks', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua4 = FactoryGirl.create(:user_access, :action => 'show', :resource => 'projectx_tasks', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "record.project.sales_id == session[:user_id]")
      ua21 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'projectx_task_requests', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "Projectx::TaskRequest.scoped")
      ua32 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'projectx_task_requests', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua311 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'projectx_task_requests', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua41 = FactoryGirl.create(:user_access, :action => 'show', :resource => 'projectx_task_requests', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "record.task.project.sales_id == session[:user_id]")
      ua41 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'projectx_type_definitions', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "Projectx::TypeDefinition.where(:active => true)")
      ua41 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'projectx_type_definitions', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua41 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'projectx_type_definitions', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua41 = FactoryGirl.create(:user_access, :action => 'index_project_task_template_index', :resource => 'projectx_type_definitions', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua41 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'projectx_task_definitions', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua41 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'projectx_task_definitions', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua41 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'projectx_task_definitions', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "Projectx::TaskDefinition.where(:active => true).order('ranking_order')")
      ua41 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'projectx_project_task_templates', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua41 = FactoryGirl.create(:user_access, :action => 'show', :resource => 'projectx_project_task_templates', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua41 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'projectx_project_task_templates', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "Projectx::ProjectTaskTemplate.where(:active => true).order('type_definition_id')")
      ua41 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'commonx_logs', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua41 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'commonx_logs', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "Commonx::Log.scoped")
      ua41 = FactoryGirl.create(:user_access, :action => 'create_project', :resource => 'commonx_logs', :role_definition_id => @role.id, :rank => 1,
                                :sql_code => "")
      ua41 = FactoryGirl.create(:user_access, :action => 'create_task', :resource => 'commonx_logs', :role_definition_id => @role.id, :rank => 1,
                                :sql_code => "")                          
      ua42 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'projectx_contracts', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "Projectx::Contract.scoped")
      ua42 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'projectx_contracts', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua42 = FactoryGirl.create(:user_access, :action => 'show', :resource => 'projectx_contracts', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua42 = FactoryGirl.create(:user_access, :action => 'show_project', :resource => 'projectx_contracts', :role_definition_id => @role.id, :rank => 1,
                                :sql_code => "")
      ua42 = FactoryGirl.create(:user_access, :action => 'index_payment', :resource => 'projectx_contracts', :role_definition_id => @role.id, :rank => 1,
                                :sql_code => "")
      ua42 = FactoryGirl.create(:user_access, :action => 'search', :resource => 'projectx_contracts', :role_definition_id => @role.id, :rank => 1,
                                :sql_code => "")
      ua43 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'projectx_payments', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "Projectx::Payment.scoped")
      ua43 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'projectx_payments', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua43 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'projectx_payments', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua43 = FactoryGirl.create(:user_access, :action => 'search', :resource => 'projectx_payments', :role_definition_id => @role.id, :rank => 1,
                                :sql_code => "")
      ua43 = FactoryGirl.create(:user_access, :action => 'show', :resource => 'projectx_payments', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua43 = FactoryGirl.create(:user_access, :action => 'show_contract', :resource => 'projectx_payments', :role_definition_id => @role.id, :rank => 1,
                                :sql_code => "")
      ua44 = FactoryGirl.create(:user_access, :action => 'show', :resource => 'customerx_customers', :role_definition_id => @role.id, :rank => 1,
                                :sql_code => "")

      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur], :login => 'thistest', :password => 'password', :password_confirmation => 'password')
      @engine_config1 = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      @proj_status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'project_status')
      @task_status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'task_status', :name => 'newnew cate', :last_updated_by_id => @u.id)
      @cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_status', :name => 'order category')
      @cust = FactoryGirl.create(:customer, :short_name => "Customer1", :zone_id => z.id, :sales_id => @u.id, :last_updated_by_id => @u.id,
                                 :quality_system_id => qs.id, :address => add, :customer_status_category_id => @cate.id)
      proj_type = FactoryGirl.create(:type_definition)
      @task_def = FactoryGirl.create(:task_definition)
      #@task_def1 = FactoryGirl.create(:task_definition, :name => 'newnew')
      @task_temp = FactoryGirl.build(:task_template, :task_definition_id => @task_def.id)
      #@task_temp1 = FactoryGirl.build(:task_template, :task_definition_id => @task_def1.id)
      @proj_temp = FactoryGirl.create(:project_task_template, :type_definition_id => proj_type.id, :task_templates => [@task_temp])
      @contract1 = FactoryGirl.create(:contract, :contract_amount => "9999.99", :id => 3)
      @proj = FactoryGirl.create(:project, :last_updated_by_id => @u.id, :customer_id => @cust.id, :sales_id => @u.id,
                                 :project_task_template_id => @proj_temp.id, :status_id => @proj_status.id, :contract => @contract1,
                                 :name => "water inspection")
      proj_log = FactoryGirl.create(:commonx_log, :resource_id => @proj.id, :resource_name => 'projectx_projects')
      @task = FactoryGirl.create(:task, :last_updated_by_id => @u.id, :project_id => @proj.id, :task_template_id => @task_temp.id)
      task_log = FactoryGirl.create(:commonx_log, :resource_id => @task.id, :resource_name => 'projectx_tasks')
      @task_request = FactoryGirl.create(:task_request, :last_updated_by_id => @u.id, :task_id => @task.id, :request_status_id => @task_status.id)
      task_req_log = FactoryGirl.create(:commonx_log, :resource_id => @task_request.id, :resource_name => 'projectx_task_requests')
      @paymnt1 = FactoryGirl.create(:payment, :contract_id => @contract1.id, :paid_amount => 101.10, :received_by_id => @u.id, :payment_type => 'Check', :received_date => '2013/04/25', :last_updated_by_id => @u.id)
      
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'task_index_view', 
                              :argument_value => Authentify::AuthentifyUtility.find_config_const('task_index_view', 'projectx')) 
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'project_index_view', 
                              :argument_value => Authentify::AuthentifyUtility.find_config_const('project_index_view', 'projectx'))                        
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'task_request_index_view', 
                              :argument_value => Authentify::AuthentifyUtility.find_config_const('task_request_index_view', 'projectx')) 
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'payment_index_view', 
                              :argument_value => Authentify::AuthentifyUtility.find_config_const('payment_index_view', 'projectx')) 
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'type_definition_index_view', 
                              :argument_value => Authentify::AuthentifyUtility.find_config_const('type_definition_index_view', 'projectx')) 
      
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'task_show_view', 
                              :argument_value => Authentify::AuthentifyUtility.find_config_const('task_show_view', 'projectx')) 
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'project_show_view', 
                              :argument_value => Authentify::AuthentifyUtility.find_config_const('project_show_view', 'projectx'))                        
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'task_request_show_view', 
                              :argument_value => Authentify::AuthentifyUtility.find_config_const('task_request_show_view', 'projectx')) 
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'payment_show_view', 
                              :argument_value => Authentify::AuthentifyUtility.find_config_const('payment_show_view', 'projectx'))
      @project_search_stat_view_config = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'project_edit_view', :argument_value => "<%= f.input :name, :label => t('Project Name') %>
    <%= f.input :project_num, :label => t('Project Number'), :readonly => true %>
    <%= f.input :customer_name_autocomplete,:input_html => { data: {autocomplete_source: SUBURI + customerx.autocomplete_customers_path}},
                :label => t('Customer'), :placeholder => '输入关键字选择客户', :required => true %>
    <%= f.input :start_date, :label => t('Start Date'), :as => :string %>
    <%= f.input :delivery_date, :label => t('Delivery Date'), :as => :string %>
    <%= f.input :estimated_delivery_date, :label => t('Estimated End Date'), :as => :string %>
    <%= f.input :project_task_template_id, :label => t('Project Type'), :collection => return_project_types, :label_method => :name, :value_method => :id,
                        :include_blank => true %>
    <%= f.input :project_desp, :label => t('Project Description'), :input_html => { :rows => 4} %>
    <%= f.input :project_instruction, :label => t('Project Instruction'), :input_html => { :rows => 4} %>
    <% if readonly?(@project, 'status_id') %>
      <%= f.input :status_name, :label => t('Project Status'), :readonly => true, :input_html => {:value => @project.status.name} %>
    <% else %>
      <%= f.input :status_id, :label => t('Project Status'), :collection => return_misc_definitions('project_status'), :label_method => :name, :value_method => :id,
                        :include_blank => true %>
    <% end %>
    <% if readonly?(@project, 'project_manager_id') %>
      <%= f.input :project_manager_name, :label => t('Projet Manager'), :readonly => true, :input_html => {:value => @project.project_manager.name} if @project.project_manager_id.present? %>
    <% else %>
      <%= f.input :project_manager_id, :label => t('Project Manager'), :collection => Authentify::UsersHelper.return_users('manage', 'projectx_projects'), :label_method => :name, :value_method => :id, 
                  :include_blank => true %>
    <% end %>
    <%= f.input :expedite, :label => t('Expedite'), :as => :boolean %>
    <% if readonly?(@project, 'sales_id') %>
      <%= f.input :sales_name, :label => t('Sales'), :readonly => true, :input_html => {:value => @project.sales.name} %>
    <% else %>
      <%= f.input :sales_id, :label => t('Sales'), :collection => Authentify::UsersHelper::return_users('sales', 'projectx_projects'), :label_method => :name, :value_method => :id,
                  :include_blank => true %>
    <% end %>
    <%= f.input :last_updated_by_name, :label => t('Last Updated By'), :input_html => {:value => @project.last_updated_by.name}, :readonly => true %>
    <%= f.simple_fields_for(:contract)  {|builder| render('contract', :f => builder)}  %>
     

    <%= f.button :submit, t('Save'), :class => BUTTONS_CLS['action'] %>")
      @project_search_stat_view_config = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'project_new_view', :argument_value => "<%= f.input :name, :label => t('Project Name') %>
    <%= f.input :project_num, :label => t('Project Number'), :readonly => true %>
    <%= f.input :customer_name_autocomplete,:input_html => { data: {autocomplete_source: SUBURI + customerx.autocomplete_customers_path}},
                :label => t('Customer'), :placeholder => '输入关键字选择客户', :required => true %>
    <%= f.input :start_date, :label => t('Start Date'), :as => :string %>
    <%#= f.input :project_date, :label => t('Project Date'), :as => :string %>
    <%= f.input :estimated_delivery_date, :label => t('Estimated End Date'), :as => :string %>
    <%= f.input :project_task_template_id, :label => t('Project Task Template'), :collection => return_project_task_templates, :label_method => :name, :value_method => :id,
                        :include_blank => true %>
    <%= f.input :project_desp, :label => t('Project Description'), :input_html => { :rows => 4} %>
    <%= f.input :project_instruction, :label => t('Project Instruction'), :input_html => { :rows => 4} %>
    <%= f.input :status_id, :label => t('Status'), :collection => return_misc_definitions('project_status'), :label_method => :name, :value_method => :id,
                        :include_blank => true %>
    <%#= f.input :project_manager_id, :label => t('Manager'), :collection => Authentify::UsersHelper.return_users('manage', 'projectx_projects') %>
    <%= f.input :expedite, :label => t('Expedite'), :as => :boolean %>
   <%= f.input :sales_id, :label => t('Sales'), :collection => Authentify::UsersHelper::return_users('sales', 'projectx_projects'), :label_method => :name, :value_method => :id,
                :include_blank => true %>
   <%= f.simple_fields_for(:contract)  {|builder| render('contract', :f => builder)}  %>

    <%= f.button :submit, t('Save'), :class => BUTTONS_CLS['action'] %>")
      @project_search_stat_view_config = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'project_search_view', :argument_value => "
              <p>
              <% if @search_stat.stat_function.present? and @search_stat.include_stats %>
              <p><%= f.input :search_option_s, :label => t('Search Option'), :collection => [t('Search'), t('Stats')], :selected => t('Search')  %></p>
          <% else %>
              <p><%= f.input :search_option_s, :label => t('Search Option'), :collection => [t('Search')], :selected => t('Search')  %></p>
              <% end %>
              </p>
          <% lf = eval(@search_stat.labels_and_fields) %>
          <p>
          <% lf.each do |field, layouts| %>
              <% if layouts[:if].nil?  or  layouts[:if]%>
                  <% layouts.delete(:if) %>
                  <%= f.input field.to_sym, layouts %>
              <% end %>
          <% end %>
          </p>
              <%= f.button :submit, t('Submit') , :class =>'btn btn-primary' %> " )



    visit '/'
      ##save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => 'password'
      click_button 'Login'
    end

    it "should visit project index page and its links" do
      #visit user_menus_path
      visit projects_path
      #save_and_open_page
      page.body.should have_content("Projects")
      click_link('Tasks')
      #save_and_open_page
      page.body.should have_content("TaskName")
      visit projects_path
      #save_and_open_page
      click_link('Edit')
      page.body.should have_content("Edit Project")
    end
    
    it "should visit task index page and its links" do
      visit project_tasks_path(@proj)
      #save_and_open_page
      page.body.should have_content("TaskName")
      click_link('Edit')
      ##save_and_open_page
      page.body.should have_content("更新项目任务")
      click_link('Back')
      visit project_tasks_path(@proj)
      click_link(@task.id.to_s)
      #save_and_open_page
      page.body.should have_content("任务内容")
      click_link('New Log')
      #save_and_open_page
      page.body.should have_content("新Log")
    end
    
    it "should visit task_request index page and its links" do
      visit task_task_requests_path(@task)
      page.body.should have_content("任务申请一览")
      click_link('Edit')
      page.body.should have_content("更新任务申请")
    end
    
    it "should visit project_type page and related project_task_template page" do
      visit type_definitions_path
      
      page.body.should have_content("项目类型一览")
      click_link('Edit')
      ##save_and_open_page
      page.body.should have_content("更新项目类型")
      visit type_definitions_path
      click_link("新项目任务模版")
      page.body.should have_content("输入项目任务模版")
      visit type_definitions_path
      click_link("项目任务模版一览")
      #save_and_open_page
      page.body.should have_content('项目样板一览') #("Project Task Templates")
      click_link(@proj_temp.id.to_s)
      #save_and_open_page
      page.body.should have_content("项目模版内容")
      click_link('New Project Task Template')
      page.body.should have_content("输入项目任务模版")
            
    end
    
    it "should visit task_definition index page on task" do
      visit task_definitions_path
      #save_and_open_page
      page.body.should have_content("Task Definitions")
      click_link('New Task Definition')
      ##save_and_open_page
      page.body.should have_content("New Task Definition")
    end

    it "should visit project index page and all its links" do
      visit projects_path
      #save_and_open_page
      page.body.should have_content("Projects")

      click_link('Tasks')
      #save_and_open_page
      page.body.should have_content("TaskName")

      visit projects_path
      click_link('Edit')
      #save_and_open_page
      page.body.should have_content("Edit Project")

      visit projects_path
      #save_and_open_page
      click_link('New Project')
      #save_and_open_page
      page.body.should have_content("New Project")

      visit project_path(@proj)
      #save_and_open_page
      page.body.should have_content("Project Info")

      visit projects_path
      click_link('Customer1')
      #save_and_open_page
      page.body.should have_content("Customer1")
      
      visit projects_path
      click_link(@proj.name)
      #save_and_open_page
      page.body.should have_content(@proj.name)
      
      visit projects_path
      click_link(@contract1.id.to_s)
      #save_and_open_page
      page.body.should have_content(@contract1.contract_amount)

      visit projects_path
      click_link('Search')
      #save_and_open_page
      page.body.should have_content("Search")
    end

    it "should visit project show page and all its links" do
      visit project_path(@proj)
      #save_and_open_page
      page.body.should have_content("Project Info")

      click_link('New Log')
      #save_and_open_page
      page.body.should have_content("新Log")
    end

    it "should visit project new page " do
      visit project_path(@proj)
      #save_and_open_page
      page.body.should have_content("Project Info")

      click_link('New Log')
      #save_and_open_page
      page.body.should have_content("新Log")
    end

    it "should visit contract index page and all its links" do
      visit contracts_path
      #save_and_open_page
      page.body.should have_content("Contracts")

      visit contracts_path
      click_link('Edit')
      #save_and_open_page
      page.body.should have_content("Edit Contract")

      visit contracts_path
      click_link(@contract1.id.to_s)
      #save_and_open_page
      page.body.should have_content("Contract Info")

      visit contracts_path
      click_link(@proj.name)
      #save_and_open_page
      page.body.should have_content(@proj.name)

      visit contracts_path
      #click_link('Search')
      #save_and_open_page
      #page.body.should have_content("Contract Search")
    end


    it "should visit contract show page and all its links" do
      visit contract_path(@contract1, {:project_id =>@proj.id})
      #save_and_open_page
      page.body.should have_content("Contract Info")

      visit contract_path(@contract1, {:project_id =>@proj.id})
      #save_and_open_page
      click_link('New Payment')
      #save_and_open_page
      page.body.should have_content("New Payment")
    end


    it "should visit payment index page and all its links" do
      visit payments_path
      #save_and_open_page
      page.body.should have_content("Payments")
      page.body.should_not have_content('New Payment')  #without @contract passed in.

      visit payments_path
      click_link('Edit')
      #save_and_open_page
      page.body.should have_content("Edit Payment")

      visit payments_path
      click_link(@paymnt1.id.to_s)
      #save_and_open_page
      page.body.should have_content("Payment Info")

      visit payments_path
      #save_and_open_page
      click_link(@paymnt1.contract_id.to_s)
      #save_and_open_page
      page.body.should have_content("Contract Info")

      visit payments_path
      click_link(@paymnt1.contract.project.name)
      #save_and_open_page
      page.body.should have_content("Project Info")
      
      #new payment link if @contract loaded
      visit contract_payments_path(@contract1)
      #save_and_open_page
      click_link('New Payment')
      page.body.should have_content('New Payment')
    end

    it "should visit payment show page and all its links" do
      visit payment_path(@paymnt1, {:contract_id => @contract1.id})
      #save_and_open_page
      page.body.should have_content("Payment Info")

    end



  end
end
