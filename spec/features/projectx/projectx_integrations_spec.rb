# encoding: utf-8
require 'spec_helper'

describe "Integrations" do
  describe "GET /projectx_integrations" do
    before(:each) do
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
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur], :login => 'thistest', :password => 'password', :password_confirmation => 'password')
      @engine_config1 = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      @proj_status = FactoryGirl.create(:misc_definition, :for_which => 'project_status')
      @task_status = FactoryGirl.create(:misc_definition, :for_which => 'task_status', :name => 'newnew cate', :last_updated_by_id => @u.id)
      @cust = FactoryGirl.create(:customer, :zone_id => z.id, :sales_id => @u.id, :last_updated_by_id => @u.id, :quality_system_id => qs.id, :address => add)
      proj_type = FactoryGirl.create(:type_definition) 
      @task_def = FactoryGirl.create(:task_definition)
      #@task_def1 = FactoryGirl.create(:task_definition, :name => 'newnew')
      @task_temp = FactoryGirl.build(:task_template, :task_definition_id => @task_def.id)
      #@task_temp1 = FactoryGirl.build(:task_template, :task_definition_id => @task_def1.id)    
      @proj_temp = FactoryGirl.create(:project_task_template, :type_definition_id => proj_type.id, :task_templates => [@task_temp])     
      @proj = FactoryGirl.create(:project, :last_updated_by_id => @u.id, :customer_id => @cust.id, :sales_id => @u.id, 
                                 :project_task_template_id => @proj_temp.id, :status_id => @proj_status.id)
      proj_log = FactoryGirl.create(:log, :project_id => @proj.id, :task_id => nil, :task_request_id => nil)
      @contract = FactoryGirl.create(:contract, :project_id => @proj.id)
      @task = FactoryGirl.create(:task, :last_updated_by_id => @u.id, :project_id => @proj.id, :task_template_id => @task_temp.id)
      task_log = FactoryGirl.create(:log, :task_id => @task.id, :project_id => nil, :task_request_id => nil)
      @task_request = FactoryGirl.create(:task_request, :last_updated_by_id => @u.id, :task_id => @task.id, :request_status_id => @task_status.id)
      task_req_log = FactoryGirl.create(:log, :task_request_id => @task_request.id, :project_id => nil, :task_id => nil)
      
      visit '/'
      #save_and_open_page
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
      page.body.should have_content("一览")
      visit projects_path
      click_link('Edit')
      page.body.should have_content("Edit Project")
    end
    
    it "should visit task index page and its links" do
      visit project_tasks_path(@proj)
      #save_and_open_page
      page.body.should have_content("一览")
      click_link('Edit')
      #save_and_open_page
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
      #save_and_open_page
      page.body.should have_content("更新项目类型")
      visit type_definitions_path
      click_link("新项目任务模版")
      page.body.should have_content("输入项目任务模版")
      visit type_definitions_path
      click_link("项目任务模版一览")
      #save_and_open_page
      page.body.should have_content("Project Templates")
      click_link(@proj_temp.id.to_s)
      #save_and_open_page
      page.body.should have_content("项目模版内容")
      click_link('New Project Task Template')
      page.body.should have_content("输入项目任务模版")
            
    end
    
    it "should visit task_definition index page on task" do
      visit task_definitions_path
      save_and_open_page
      page.body.should have_content("Task Definitions")
      click_link('New Task Definition')
      save_and_open_page
      page.body.should have_content("New Task Definition")
    end
  end
end
