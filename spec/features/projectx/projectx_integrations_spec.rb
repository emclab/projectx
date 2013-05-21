# encoding: utf-8
require 'spec_helper'

describe "Integrations" do
  describe "GET /projectx_integrations" do
    before(:each) do
      @project_num_time_gen = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'project_num_time_gen', :argument_value => ' Projectx::Project.last.nil? ? (Time.now.strftime("%Y%m%d") + "-"  + 112233.to_s + "-" + rand(100..999).to_s) :  (Time.now.strftime("%Y%m%d") + "-"  + (Projectx::Project.last.project_num.split("-")[-2].to_i + 555).to_s + "-" + rand(100..999).to_s)')
      @project_has_sales_config = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'project_has_sales', :argument_value => 'true')
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'payment_terms', :argument_value => 'Cash,Check,Visa, MasterCard')
      @payment_type = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'payment_type', :argument_value => 'Cash, Check, Coupon, Credit Card, Credit Letter')

      qs = Customerx::MiscDefinition.new({:name => 'ISO9000', :for_which => 'customer_quality_system'}, :as => :role_new)
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
      ua41 = FactoryGirl.create(:user_access, :action => 'index_new_project_task_template', :resource => 'projectx_type_definitions', :role_definition_id => @role.id, :rank => 1,
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
      ua41 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'projectx_logs', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua41 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'projectx_logs', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "Projectx::Log.scoped")
      ua41 = FactoryGirl.create(:user_access, :action => 'create_project', :resource => 'projectx_logs', :role_definition_id => @role.id, :rank => 1,
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
      @proj_status = FactoryGirl.create(:misc_definition, :for_which => 'project_status')
      @task_status = FactoryGirl.create(:misc_definition, :for_which => 'task_status', :name => 'newnew cate', :last_updated_by_id => @u.id)
      @cate = FactoryGirl.create(:customerx_misc_definition, :for_which => 'customer_status', :name => 'order category')
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
      proj_log = FactoryGirl.create(:log, :project_id => @proj.id, :task_id => nil, :task_request_id => nil)
      @task = FactoryGirl.create(:task, :last_updated_by_id => @u.id, :project_id => @proj.id, :task_template_id => @task_temp.id)
      task_log = FactoryGirl.create(:log, :task_id => @task.id, :project_id => nil, :task_request_id => nil)
      @task_request = FactoryGirl.create(:task_request, :last_updated_by_id => @u.id, :task_id => @task.id, :request_status_id => @task_status.id)
      task_req_log = FactoryGirl.create(:log, :task_request_id => @task_request.id, :project_id => nil, :task_id => nil)
      @paymnt1 = FactoryGirl.create(:payment, :contract_id => @contract1.id, :paid_amount => 101.10, :received_by_id => @u.id, :payment_type => 'Check', :received_date => '2013/04/25', :last_updated_by_id => @u.id)


      visit '/'
      ##save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => 'password'
      click_button 'Login'
    end

    it "should visit project index page and its links" do
      #visit user_menus_path
      visit projects_path
      ##save_and_open_page
      page.body.should have_content("Projects")
      click_link('Tasks')
      ##save_and_open_page
      page.body.should have_content("项目任务一览")
      visit projects_path
      click_link('Edit')
      page.body.should have_content("Edit Project")
    end
    
    it "should visit task index page and its links" do
      visit project_tasks_path(@proj)
      ##save_and_open_page
      page.body.should have_content("一览")
      click_link('Edit')
      ##save_and_open_page
      page.body.should have_content("更新项目任务")
      click_link('Back')
      visit project_tasks_path(@proj)
      click_link(@task.id.to_s)
      ##save_and_open_page
      page.body.should have_content("任务内容")
      click_link('New Log')
      ##save_and_open_page
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
      save_and_open_page
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
      page.body.should have_content("项目任务一览")

      visit projects_path
      click_link('Edit')
      #save_and_open_page
      page.body.should have_content("Edit Project")

      visit projects_path
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
      click_link('Search')
      #save_and_open_page
      page.body.should have_content("Contract Search")
    end


    it "should visit contract show page and all its links" do
      visit contract_path(@contract1, {:project_id =>@proj.id})
      #save_and_open_page
      page.body.should have_content("Contract Info")

      visit contract_path(@contract1, {:project_id =>@proj.id})
      click_link('New Payment')
      #save_and_open_page
      page.body.should have_content("New Payment")
    end


    it "should visit payment index page and all its links" do
      visit payments_path
      #save_and_open_page
      page.body.should have_content("Payments")

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

    end

    it "should visit payment show page and all its links" do
      visit payment_path(@paymnt1, {:contract_id => @contract1.id})
      #save_and_open_page
      page.body.should have_content("Payment Info")

    end



  end
end
