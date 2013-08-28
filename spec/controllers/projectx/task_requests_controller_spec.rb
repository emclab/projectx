#encoding: utf-8
require 'spec_helper'

module Projectx
  describe TaskRequestsController do
    before(:each) do
      controller.should_receive(:require_signin)
    end
    
    render_views
    before(:each) do
       @project_num_time_gen = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'project_num_time_gen', :argument_value => ' Projectx::Project.last.nil? ? (Time.now.strftime("%Y%m%d") + "-"  + 112233.to_s + "-" + rand(100..999).to_s) :  (Time.now.strftime("%Y%m%d") + "-"  + (Projectx::Project.last.project_num.split("-")[-2].to_i + 555).to_s + "-" + rand(100..999).to_s)')
       @project_has_sales_config = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'project_has_sales', :argument_value => 'true')
       @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
       @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'payment_terms', :argument_value => 'Cash,Check,Visa, MasterCard')
       @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'task_request_index_view', 
                              :argument_value => Authentify::AuthentifyUtility.find_config_const('task_request_index_view', 'projectx')) 
       @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'task_request_show_view', 
                              :argument_value => Authentify::AuthentifyUtility.find_config_const('task_request_show_view', 'projectx')) 
      
       z = FactoryGirl.create(:zone, :zone_name => 'hq')
       type = FactoryGirl.create(:group_type, :name => 'employee')
       ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
       @role = FactoryGirl.create(:role_definition)
        #user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'projectx_misc_definitions', :role_definition_id => role.id, :rank => 1,
        #:sql_code => "Projectx::MiscDefinition.where(:active => true).order('ranking_order')")
        ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        proj_type = FactoryGirl.create(:type_definition)
        proj_temp = FactoryGirl.create(:project_task_template, :type_definition_id => proj_type.id)
        cust = FactoryGirl.create(:customer)
        @proj = FactoryGirl.create(:project, :project_task_template_id => proj_temp.id, :customer_id => cust.id)
        @proj1 = FactoryGirl.create(:project, :name => 'newnew', :project_task_template_id => proj_temp.id, :project_num => 'newnew234')
        @task_def = FactoryGirl.create(:task_definition)
        @task_def1 = FactoryGirl.create(:task_definition, :name => 'newnew')
        t_temp = FactoryGirl.create(:task_template, :task_definition_id => @task_def.id)
        @task = FactoryGirl.create(:task, :project_id => @proj.id, :task_template_id => t_temp.id)
        @task1 = FactoryGirl.create(:task, :project_id => @proj1.id, :task_template_id => t_temp.id)
    end
    
    describe "GET 'index'" do
      it "returns all task reqeusts" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'projectx_task_requests', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Projectx::TaskRequest.order('request_date DESC')")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'task_status')
        qs = FactoryGirl.create(:task_request, :last_updated_by_id => @u.id, :task_id => @task.id, :request_status_id => status.id)
        qs1 = FactoryGirl.create(:task_request, :last_updated_by_id => @u.id, :task_id => @task1.id, :request_status_id => status.id)
        get 'index' , {:use_route => :projectx}
        assigns(:task_requests).should =~ [qs,qs1] 
      end
      
      it "should only return request for the task" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'projectx_task_requests', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Projectx::TaskRequest.order('request_date DESC')")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'task_status')
        qs = FactoryGirl.create(:task_request, :last_updated_by_id => @u.id, :task_id => @task.id, :request_status_id => status.id)
        qs1 = FactoryGirl.create(:task_request, :last_updated_by_id => @u.id, :task_id => @task1.id, :request_status_id => status.id)
        get 'index' , {:use_route => :projectx, :task_id => @task1.id}
        assigns(:task_requests).should eq([qs1]) 
      end
      
      it "should redirect for no right" do
        user_access = FactoryGirl.create(:user_access, :action => 'no-index', :resource => 'projectx_task_requests', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Projectx::TaskRequest.order('request_date DESC')")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'task_status')
        qs = FactoryGirl.create(:task_request, :last_updated_by_id => @u.id, :task_id => @task.id, :request_status_id => status.id)
        qs1 = FactoryGirl.create(:task_request, :last_updated_by_id => @u.id, :task_id => @task1.id, :request_status_id => status.id)
        get 'index' , {:use_route => :projectx, :task_id => @task1.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=index and resource=projectx/task_requests")
      end
    end
  
    describe "GET 'new'" do
      it "should be success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'projectx_task_requests', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'task_status')
        get 'new' , {:use_route => :projectx, :task_id => @task1.id}
        response.should be_success
      end
      
      it "should redirect if no right" do
        user_access = FactoryGirl.create(:user_access, :action => 'no-create', :resource => 'projectx_task_requests', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'task_status')
        get 'new' , {:use_route => :projectx, :task_id => @task.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=new and resource=projectx/task_requests")
      end
    end
  
    describe "GET 'create'" do
      it "create successfully" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'projectx_task_requests', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'task_status')
        qs = FactoryGirl.attributes_for(:task_request, :last_updated_by_id => @u.id,  :request_status_id => status.id)
        get 'create' , {:use_route => :projectx, :task_request => qs, :task_id => @task1.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!") 
      end
      
      it "should render 'new' for data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'projectx_task_requests', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'task_status')
        qs = FactoryGirl.attributes_for(:task_request, :last_updated_by_id => @u.id,  :request_status_id => status.id, :name => nil)
        get 'create' , {:use_route => :projectx, :task_request => qs, :task_id => @task1.id}
        response.should render_template("new")
      end
    end
  
    describe "GET 'edit'" do
      it "returns success" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'projectx_task_requests', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'task_status')
        qs = FactoryGirl.create(:task_request, :last_updated_by_id => @u.id,  :request_status_id => status.id)
        get 'edit' , {:use_route => :projectx, :task_id => @task1.id, :id => qs.id}
        response.should be_success
      end
    end
  
    describe "GET 'update'" do
      it "should update" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'projectx_task_requests', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'task_status')
        qs = FactoryGirl.create(:task_request, :last_updated_by_id => @u.id,  :request_status_id => status.id)
        get 'update' , {:use_route => :projectx, :id => qs.id, :task_id => @task1.id, :task_request => {:name => 'new new'}}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!") 
      end
      
      it "should render 'edit' for data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'projectx_task_requests', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'task_status')
        qs = FactoryGirl.create(:task_request, :last_updated_by_id => @u.id,  :request_status_id => status.id)
        get 'update' , {:use_route => :projectx, :id => qs.id, :task_id => @task1.id, :task_request => {:name => ''}}
        response.should render_template("edit")
      end
    end
  
    describe "GET 'show'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource => 'projectx_task_requests', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'task_status')
        qs = FactoryGirl.create(:task_request, :last_updated_by_id => @u.id,  :request_status_id => status.id)
        get 'show' , {:use_route => :projectx, :id => qs.id, :task_id => @task1.id}
        response.should
      end
    end
  
  end
end
