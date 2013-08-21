# encoding: utf-8
require 'spec_helper'

module Projectx
  describe TasksController do
    before(:each) do
      controller.should_receive(:require_signin)
      @project_num_time_gen = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'project_num_time_gen', :argument_value => ' Projectx::Project.last.nil? ? (Time.now.strftime("%Y%m%d") + "-"  + 112233.to_s + "-" + rand(100..999).to_s) :  (Time.now.strftime("%Y%m%d") + "-"  + (Projectx::Project.last.project_num.split("-")[-2].to_i + 555).to_s + "-" + rand(100..999).to_s)')
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
    end
    
    render_views
    before(:each) do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        @role = FactoryGirl.create(:role_definition)
        @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'task_index_view', 
                              :argument_value => "This is a view") 
        #user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'projectx_misc_definitions', :role_definition_id => role.id, :rank => 1,
        #:sql_code => "Projectx::MiscDefinition.where(:active => true).order('ranking_order')")
        ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        proj_type = FactoryGirl.create(:type_definition)
        @task_def = FactoryGirl.create(:task_definition)
        @task_def1 = FactoryGirl.create(:task_definition, :name => 'newnew')
        @task_temp = FactoryGirl.build(:task_template, :task_definition_id => @task_def.id)
        @task_temp1 = FactoryGirl.build(:task_template, :task_definition_id => @task_def1.id)
        proj_temp = FactoryGirl.create(:project_task_template, :type_definition_id => proj_type.id, :task_templates => [@task_temp, @task_temp1])
        cust = FactoryGirl.create(:customer)
        @proj = FactoryGirl.create(:project, :project_task_template_id => proj_temp.id, :customer_id => cust.id)
        @proj1 = FactoryGirl.create(:project, :name => 'newnew', :project_task_template_id => proj_temp.id)
    end
      
    describe "GET 'index'" do
      
      it "return task for the project id" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'projectx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Projectx::Task.order('created_at DESC')")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:task, :last_updated_by_id => @u.id, :project_id => @proj.id, :task_template_id => @task_temp.id)
        qs1 = FactoryGirl.create(:task, :last_updated_by_id => @u.id, :project_id => @proj1.id, :task_template_id => @task_temp1.id)
        get 'index' , {:use_route => :projectx, :project_id => @proj.id}
        #response.should be_success
        assigns(:tasks).should eq([qs])  
      end
      
      it "should return all if no project_id passed in" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'projectx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Projectx::Task.where(:cancelled => false).order('created_at DESC')")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:task, :last_updated_by_id => @u.id, :project_id => @proj.id, :task_template_id => @task_temp.id)
        qs1 = FactoryGirl.create(:task, :last_updated_by_id => @u.id, :project_id => @proj1.id, :task_template_id => @task_temp1.id)
        get 'index' , {:use_route => :projectx}
        #response.should be_success
        assigns(:tasks).should =~ [qs, qs1]

      end
      
      it "should redirect if no right" do
        user_access = FactoryGirl.create(:user_access, :action => 'no-index', :resource => 'projectx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Projectx::Task.where(:cancelled => false).order('created_at DESC')")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:task, :last_updated_by_id => @u.id, :project_id => @proj.id, :task_template_id => @task_temp.id)
        qs1 = FactoryGirl.create(:task, :last_updated_by_id => @u.id, :project_id => @proj1.id, :task_template_id => @task_temp1.id)
        get 'index' , {:use_route => :projectx}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=index and resource=projectx/tasks")
      end
    end
  
    describe "GET 'new'" do
      it "should be success for user with right" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'projectx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)       
        get 'new' , {:use_route => :projectx, :project_id => @proj.id}
        response.should be_success
      end
    end
  
    describe "GET 'create'" do
      it "should create for user with right" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'projectx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.attributes_for(:task, :last_updated_by_id => @u.id, :task_template_id => @task_temp.id)       
        get 'create' , {:use_route => :projectx, :project_id => @proj.id, :task => qs}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=任务已保存!")
      end
      
      it "should render new if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'projectx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.attributes_for(:task, :last_updated_by_id => @u.id, :task_template_id => @task_temp.id, :start_date => nil)       
        get 'create' , {:use_route => :projectx, :project_id => @proj.id, :task => qs}
        response.should render_template("new")
      end
    end
  
    describe "GET 'edit'" do
      it "should be success for user with right" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'projectx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id) 
        qs = FactoryGirl.create(:task, :last_updated_by_id => @u.id, :task_template_id => @task_temp.id)      
        get 'edit' , {:use_route => :projectx, :project_id => @proj.id, :id => qs.id}
        response.should be_success
      end
    end
  
    describe "GET 'update'" do
      it "should create for user with right" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'projectx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:task, :last_updated_by_id => @u.id, :task_template_id => @task_temp.id)       
        get 'update' , {:use_route => :projectx, :project_id => @proj.id, :id => qs.id, :task => {:task_template_id => 4}}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=任务已更新!")
      end
      
      it "should render new if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'projectx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:task, :last_updated_by_id => @u.id, :task_template_id => @task_temp.id)       
        get 'update' , {:use_route => :projectx, :project_id => @proj.id, :id => qs.id, :task => {:finish_date => nil}}
        response.should render_template("edit")
      end
    end
  
    describe "GET 'show'" do
      it "show" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource => 'projectx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:task, :last_updated_by_id => @u.id, :task_template_id => @task_temp.id)       
        get 'show' , {:use_route => :projectx, :project_id => @proj.id, :id => qs.id}
        response.should be_success
      end
    end
   
  end
end
