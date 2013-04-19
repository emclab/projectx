require 'spec_helper'

module Projectx
  describe LogsController do
    before(:each) do
      controller.should_receive(:require_signin)
    end
  
    render_views
    
    before(:each) do 
      @cate = FactoryGirl.create(:misc_definition, :for_which => 'customer_status', :name => 'order category')
      @z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => @z.id)
      @role = FactoryGirl.create(:role_definition)  
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      ur1 = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul1 = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id+1)
      @u1 = FactoryGirl.create(:user, :user_levels => [ul1], :user_roles => [ur1], :name => 'a guy', :login => 'nenn876', :email => 'new@a.com')
      proj_type = FactoryGirl.create(:type_definition)
      @task_def = FactoryGirl.create(:task_definition)
      @task_def1 = FactoryGirl.create(:task_definition, :name => 'newnew')
      @task_temp = FactoryGirl.build(:task_template, :task_definition_id => @task_def.id)
      @task_temp1 = FactoryGirl.build(:task_template, :task_definition_id => @task_def1.id)
      @proj_temp = FactoryGirl.create(:project_task_template, :type_definition_id => proj_type.id, :task_templates => [@task_temp, @task_temp1])  
    end
    
    describe "GET 'index'" do
      it "returns project logs for users with index right with @project passes in" do
        user_access = FactoryGirl.create(:user_access, :action => 'index_project', :resource => 'projectx_logs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Projectx::Log.where('project_id > ? AND created_at > ?', 0, 2.years.ago).order('id DESC')")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :sales_id => @u.id + 1, 
                                  :zone_id => @z.id, :customer_status_category_id => @cate.id)
        lead = FactoryGirl.create(:project, :customer_id => cust.id)
        log = FactoryGirl.create(:log, :project_id => lead.id, :task_id => nil, :task_request_id => nil)
        get 'index', {:use_route => :projectx, :project_id => lead.id, :which_table => 'project', :subaction => 'project'}
        assigns(:logs).should eq([log])
      end
      
      it "returns project logs for users with index group right without @project passes in" do
        user_access = FactoryGirl.create(:user_access, :action => 'index_project', :resource => 'projectx_logs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Projectx::Log.joins(:project).
        where(:projectx_projects => {:sales_id => Authentify::UserLevel.where(:sys_user_group_id => session[:user_privilege].user_group_ids + session[:user_privilege].sub_group_ids).select('user_id')}).
        where('projectx_logs.project_id > ? AND projectx_logs.created_at > ?', 0, 2.years.ago).order('id DESC')")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :sales_id => @u.id , 
                                  :zone_id => @z.id, :customer_status_category_id => @cate.id)
        cust1 = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u1.id, :sales_id => @u1.id, 
                                  :zone_id => @z.id, :customer_status_category_id => @cate.id, :name => 'newnew', :short_name => 'manman')
        lead = FactoryGirl.create(:project, :customer_id => cust.id)
        lead1 = FactoryGirl.create(:project, :customer_id => cust1.id, :name => 'newnew', :project_num =>'nodup')
        log = FactoryGirl.create(:log, :project_id => lead.id, :task_id => nil, :task_request_id => nil)
        log1 = FactoryGirl.create(:log, :project_id => lead1.id, :task_id => nil, :task_request_id => nil)
        get 'index', {:use_route => :projectx, :project_id => nil, :which_table => 'project', :subaction => 'project'}
        assigns(:logs).should eq([log1, log])
      end
      
      it "should return all logs for task_request for user with index right without @task_request passes in" do
        user_access = FactoryGirl.create(:user_access, :action => 'index_task_request', :resource => 'projectx_logs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Projectx::Log.joins(:task_request => {:task => :project}).
        where(:projectx_projects => {:sales_id => session[:user_id]}).
        where('projectx_logs.task_request_id > ? AND projectx_logs.created_at > ?', 0, 2.years.ago)")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :sales_id => @u.id + 1, :customer_status_category_id => @cate.id)
        proj = FactoryGirl.create(:project, :customer_id => cust.id)
        task = FactoryGirl.create(:task, :project_id => proj.id)
        lead = FactoryGirl.create(:task_request, :task_id => task.id)
        log = FactoryGirl.create(:log, :task_request_id => lead.id, :project_id => nil, :task_id => nil)
        log1 = FactoryGirl.create(:log, :log => 'newnew', :task_request_id => lead.id, :project_id => nil, :task_id => nil)
        get 'index', {:use_route => :projectx, :which_table => 'task_request', :subaction => 'task_request'}
        #response.should be_success
        assigns(:logs).should eq([log, log1])
      end
      
      it "should return all logs for task_request for user with index right with @task_request passes in" do
        user_access = FactoryGirl.create(:user_access, :action => 'index_task_request', :resource => 'projectx_logs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Projectx::Log.joins(:task_request => {:task => :project}).
        where(:projectx_projects => {:sales_id => session[:user_id]}).
        where('projectx_logs.task_request_id > ? AND projectx_logs.created_at > ?', 0, 2.years.ago)")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :sales_id => @u.id + 1, :customer_status_category_id => @cate.id)
        proj = FactoryGirl.create(:project, :customer_id => cust.id)
        task = FactoryGirl.create(:task, :project_id => proj.id)
        lead = FactoryGirl.create(:task_request, :task_id => task.id)
        log = FactoryGirl.create(:log, :task_request_id => lead.id + 1, :project_id => nil, :task_id => nil)
        log1 = FactoryGirl.create(:log, :log => 'newnew', :task_request_id => lead.id, :project_id => nil, :task_id => nil)
        get 'index', {:use_route => :projectx, :task_request_id => lead.id, :which_table => 'task_request', :subaction => 'task_request'}
        assigns(:logs).should eq([log1])
      end
      
      it "should return all logs for task for user with index right matching zone_id without @task passes in" do
        user_access = FactoryGirl.create(:user_access, :action => 'index_task', :resource => 'projectx_logs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Projectx::Log.joins(:task => :project).
        where(:projectx_projects => {:sales_id => Authentify::UserLevel.joins(:sys_user_group).where(:authentify_sys_user_groups =>{:zone_id => session[:user_privilege].user_zone_ids}).select('user_id')}).
        where('projectx_logs.task_id > ? AND projectx_logs.created_at > ?', 0, 2.years.ago)")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :sales_id => @u.id, :customer_status_category_id => @cate.id)
        proj = FactoryGirl.create(:project, :customer_id => cust.id, :sales_id => @u.id, :project_task_template_id => @proj_temp.id,)
        lead = FactoryGirl.create(:task, :project_id => proj.id, :task_template_id => @task_temp.id)
        log = FactoryGirl.create(:log, :task_id => lead.id, :project_id => nil, :task_request_id => nil)
        log1 = FactoryGirl.create(:log, :log => 'newnew', :task_id => lead.id, :project_id => nil, :task_request_id => nil)
        get 'index', {:use_route => :projectx, :which_table => 'task', :subaction => 'task'}
        assigns(:logs).should eq([log, log1])
      end
       
      it "should return all logs for task for user with index right with @task passes in" do
        user_access = FactoryGirl.create(:user_access, :action => 'index_task', :resource => 'projectx_logs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Projectx::Log.joins(:task => :project).
        where(:projectx_projects => {:sales_id => Authentify::UserLevel.joins(:sys_user_group).where(:authentify_sys_user_groups =>{:zone_id => session[:user_privilege].user_zone_ids}).select('user_id')}).
        where('projectx_logs.task_id > ? AND projectx_logs.created_at > ?', 0, 2.years.ago)")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :sales_id => @u.id, :customer_status_category_id => @cate.id)
        proj = FactoryGirl.create(:project, :customer_id => cust.id, :sales_id => @u.id, :project_task_template_id => @proj_temp.id,)
        lead = FactoryGirl.create(:task, :project_id => proj.id, :task_template_id => @task_temp.id)
        log = FactoryGirl.create(:log, :task_id => lead.id, :project_id => nil, :task_request_id => nil)
        log1 = FactoryGirl.create(:log, :log => 'newnew', :task_id => lead.id + 1, :project_id => nil, :task_request_id => nil)
        get 'index', {:use_route => :projectx, :task_id => lead.id, :which_table => 'task', :subaction => 'task'}
        assigns(:logs).should eq([log])
      end
   
    end
  
    describe "GET 'new'" do
      it "should returns success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create_project', :resource => 'projectx_logs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :sales_id => @u.id + 1, 
                                  :zone_id => @z.id, :customer_status_category_id => @cate.id)
        lead = FactoryGirl.create(:project, :customer_id => cust.id)
        #log = FactoryGirl.create(:log, :project_id => lead.id, :task_id => nil, :task_request_id => nil)
        get 'new', {:use_route => :projectx, :project_id => lead.id, :which_table => 'project', :subaction => 'project'}
        response.should be_success
      end
    end
  
    describe "GET 'create'" do
      it "should create project log successfully" do
        user_access = FactoryGirl.create(:user_access, :action => 'create_project', :resource => 'projectx_logs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :sales_id => @u.id + 1, 
                                  :zone_id => @z.id, :customer_status_category_id => @cate.id)
        lead = FactoryGirl.create(:project, :customer_id => cust.id)
        log = FactoryGirl.attributes_for(:log, :project_id => lead.id, :task_id => nil, :task_request_id => nil)
        get 'create', {:use_route => :projectx, :log => log, :project_id => lead.id, :which_table => 'project', :subaction => 'project'}
        response.should redirect_to project_path(lead) #URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Log Saved!")
      end
      
      it "should create task log successfully" do
        user_access = FactoryGirl.create(:user_access, :action => 'create_task', :resource => 'projectx_logs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :sales_id => @u.id + 1, 
                                  :zone_id => @z.id, :customer_status_category_id => @cate.id)
        lead = FactoryGirl.create(:project, :customer_id => cust.id)
        task = FactoryGirl.create(:task, :project_id => lead.id)
        log = FactoryGirl.attributes_for(:log, :project_id => nil, :task_id => task.id, :task_request_id => nil)
        get 'create', {:use_route => :projectx, :log => log, :task_id => task.id, :which_table => 'task', :subaction => 'task'}
        response.should redirect_to project_task_path(task.project, task)  #URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Log Saved!")
      end
      
      it "should create task_request log successfully" do
        user_access = FactoryGirl.create(:user_access, :action => 'create_task_request', :resource => 'projectx_logs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :sales_id => @u.id + 1, 
                                  :zone_id => @z.id, :customer_status_category_id => @cate.id)
        lead = FactoryGirl.create(:project, :customer_id => cust.id)
        task = FactoryGirl.create(:task, :project_id => lead.id)
        t_req = FactoryGirl.create(:task_request, :task_id => task.id)
        log = FactoryGirl.attributes_for(:log, :project_id => nil, :task_id => nil, :task_request_id => t_req.id)
        get 'create', {:use_route => :projectx, :log => log, :task_request_id => t_req.id, :which_table => 'task_request', :subaction => 'task_request'}
        response.should redirect_to task_task_request_path(t_req.task, t_req)  #URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Log Saved!")
      end
    end
  
  end
end
