require 'spec_helper'

module Projectx
  describe TaskDefinitionsController do

    before(:each) do
      controller.should_receive(:require_signin)
      #controller.should_receive(:require_employee)
    end

    render_views

    describe "GET 'index'" do
=begin
      before :each do
        type_of_user = FactoryGirl.create(:group_type, :name => 'employee')
        z1 = FactoryGirl.create(:zone, :zone_name => 'hq')
        z2 = FactoryGirl.create(:zone, :zone_name => 'regional')
        z3 = FactoryGirl.create(:zone, :zone_name => 'another regional')

        ceo_group = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type_of_user.id, :zone_id => z1.id)
        regional_group = FactoryGirl.create(:sys_user_group, :user_group_name => 'regional_manager', :group_type_id => type_of_user.id, :zone_id => z2.id)
        sales_group_1 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => type_of_user.id, :zone_id => z1.id)
        sales_group_2 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => type_of_user.id, :zone_id => z2.id)
        sales_group_3 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => type_of_user.id, :zone_id => z3.id)
        sales_group_4 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => type_of_user.id, :zone_id => z3.id)

        global_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_task_definitions', :action => 'index')
        regional_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_task_definitions', :action => 'index')
        individual_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_task_definitions', :action => 'index')
        no_individual_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_task_definitions', :action => 'xxxxx')

        ceo_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ceo_group.id, :sys_action_on_table_id => global_access_right.id)
        regional_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => regional_group.id, :sys_action_on_table_id => regional_access_right.id)
        sales_1_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => sales_group_1.id, :sys_action_on_table_id => individual_access_right.id)
        sales_2_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => sales_group_2.id, :sys_action_on_table_id => individual_access_right.id)
        sales_3_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => sales_group_3.id, :sys_action_on_table_id => individual_access_right.id)
        sales_4_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => sales_group_4.id, :sys_action_on_table_id => no_individual_access_right.id)

        @ceo_ul       = FactoryGirl.build(:user_level, :sys_user_group_id => ceo_group.id)
        @regional_ul  = FactoryGirl.build(:user_level, :sys_user_group_id => regional_group.id)
        @sales_1_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_2.id)
        @sales_2_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_2.id)
        @sales_3_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_3.id)
        @sales_4_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_4.id)

        @ceo_u = FactoryGirl.create(:user, :name => 'ceo', :login => 'ceo111', :email => 'ceo@a.com', :user_levels => [@ceo_ul])
        @regional_u = FactoryGirl.create(:user, :name => 'regional', :login => 'regional', :email => 'regional@a.com', :user_levels => [@regional_ul])
        @individual_1_u = FactoryGirl.create(:user, :name => 'name1', :login => 'login1', :email => 'name1@a.com', :user_levels => [@sales_1_ul])
        @individual_2_u = FactoryGirl.create(:user, :name => 'name2', :login => 'login2', :email => 'name2@a.com', :user_levels => [@sales_2_ul])
        @individual_3_u = FactoryGirl.create(:user, :name => 'name3', :login => 'login3', :email => 'name3@a.com', :user_levels => [@sales_3_ul])
        @individual_4_u = FactoryGirl.create(:user, :name => 'name4', :login => 'login4', :email => 'name4@a.com', :user_levels => [@sales_4_ul])

        @task_def_1 = FactoryGirl.create(:task_definition, :name => 'Task_Def_1')
        @task_def_2 = FactoryGirl.create(:task_definition, :name => 'Task_Def_2')
        @task_def_3 = FactoryGirl.create(:task_definition, :name => 'Task_Def_3')

      end
=end
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
        assigns(:task_definitions).should eq([ls, ls1]) 
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
        response.should redirect_to task_definitions_path
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
      it "should create for user with right" do
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
        response.should redirect_to task_definitions_path
      end
      
      it "should display render templdate new if data error" do
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
