require 'spec_helper'

module Projectx
  describe TaskDefinitionsController do

    before(:each) do
      controller.should_receive(:require_signin)
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
    end

    render_views

    describe "GET 'index'" do

      it "should index for all definition for manager" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'projectx_task_definitions', :role_definition_id => role.id, :rank => 1,
        :sql_code => "Projectx::TaskDefinition.order('ranking_order')")
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        ls = FactoryGirl.create(:task_definition, :active => true, :last_updated_by_id => u.id)
        ls1 = FactoryGirl.create(:task_definition,:name => 'new', :active => false, :last_updated_by_id => u.id)
        get 'index' , {:use_route => :projectx}
        assigns(:task_definitions).should =~ [ls, ls1] 
      end
      
      it "should index for active definition for manager" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'projectx_task_definitions', :role_definition_id => role.id, :rank => 1,
        :sql_code => "Projectx::TaskDefinition.where(:active => true).order('ranking_order')")
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        ls = FactoryGirl.create(:task_definition, :active => true, :last_updated_by_id => u.id)
        ls1 = FactoryGirl.create(:task_definition,:name => 'new', :active => false, :last_updated_by_id => u.id)
        get 'index' , {:use_route => :projectx}
        assigns(:task_definitions).should eq([ls]) 
      end
      
      it "should redirect if there is no right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access = FactoryGirl.create(:user_access, :action => 'no-index', :resource => 'projectx_task_definitions', :role_definition_id => role.id, :rank => 1,
        :sql_code => "Projectx::TaskDefinition.where(:active => true).order('ranking_order')")
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        ls = FactoryGirl.create(:task_definition, :active => true, :last_updated_by_id => u.id)
        get 'index' , {:use_route => :projectx}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=index and resource=projectx/task_definitions") 
      end
    end
    
    describe "GET 'new'" do
      it "should redirect if there is no right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access = FactoryGirl.create(:user_access, :action => 'no-new', :resource => 'projectx_task_definitions', :role_definition_id => role.id, :rank => 1,
        :sql_code => "")
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        #ls = FactoryGirl.create(:task_definition, :active => true, :last_updated_by_id => u.id)
        get 'new' , {:use_route => :projectx}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=new and resource=projectx/task_definitions") 
      end
      
      it "should be success for user with right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'projectx_task_definitions', :role_definition_id => role.id, :rank => 1,
        :sql_code => "")
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        #ls = FactoryGirl.create(:task_definition, :active => true, :last_updated_by_id => u.id)
        get 'new' , {:use_route => :projectx}
        response.should be_success
      end
    end
    
    describe "GET 'create'" do
      it "should create for user with right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'projectx_task_definitions', :role_definition_id => role.id, :rank => 1,
        :sql_code => "")
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        ls = FactoryGirl.attributes_for(:task_definition, :active => true, :last_updated_by_id => u.id)
        get 'create' , {:use_route => :projectx, :task_definition => ls}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end
      
      it "should display render templdate new if data error" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'projectx_task_definitions', :role_definition_id => role.id, :rank => 1,
        :sql_code => "")
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        ls = FactoryGirl.attributes_for(:task_definition, :active => true, :last_updated_by_id => u.id, :name => nil)
        get 'create' , {:use_route => :projectx, :task_definition => ls}
        response.should render_template('new')
      end
    end
    
    describe "GET edit" do
      it "should redirect if there is no right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access = FactoryGirl.create(:user_access, :action => 'no-new', :resource => 'projectx_task_definitions', :role_definition_id => role.id, :rank => 1,
        :sql_code => "")
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        ls = FactoryGirl.create(:task_definition, :active => true, :last_updated_by_id => u.id)
        get 'edit' , {:use_route => :projectx, :id => ls.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=edit and resource=projectx/task_definitions") 
      end
      
      it "should be success for user with right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'projectx_task_definitions', :role_definition_id => role.id, :rank => 1,
        :sql_code => "")
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        ls = FactoryGirl.create(:task_definition, :active => true, :last_updated_by_id => u.id)
        get 'edit' , {:use_route => :projectx, :id => ls.id}
        response.should be_success
      end
    end
    
    describe "GET update" do
      it "should update for user with right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'projectx_task_definitions', :role_definition_id => role.id, :rank => 1,
        :sql_code => "")
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        ls = FactoryGirl.create(:task_definition, :active => true, :last_updated_by_id => u.id)
        get 'update' , {:use_route => :projectx, :id => ls.id, :task_definition => {:name => 'new new'}}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render templdate new if data error" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'projectx_task_definitions', :role_definition_id => role.id, :rank => 1,
        :sql_code => "")
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        ls = FactoryGirl.create(:task_definition, :active => true, :last_updated_by_id => u.id)
        get 'update' , {:use_route => :projectx, :id => ls.id, :task_definition => {:name => ''}}
        response.should render_template('edit')
      end
    end
   
  end
end
