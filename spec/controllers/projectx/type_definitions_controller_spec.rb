require 'spec_helper'

module Projectx
  describe TypeDefinitionsController do

    before(:each) do
      controller.should_receive(:require_signin)
      controller.should_receive(:require_employee)
    end

    render_views

    describe "GET 'index'" do
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

        global_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_type_definitions', :action => 'index_global')
        regional_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_type_definitions', :action => 'index_regional')
        individual_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_type_definitions', :action => 'index')
        no_individual_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_type_definitions', :action => 'xxxxx')

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

        @prj_type_def_1 = FactoryGirl.create(:type_definition, :name => 'Project_Type_1', :for_what => 'project')
        @task_type_def_1 = FactoryGirl.create(:type_definition, :name => 'Task_Type_1', :for_what => 'task')
        @prj_type_def_2 = FactoryGirl.create(:type_definition, :name => 'Project_Type_2', :for_what => 'project')
        @prj_type_def_3 = FactoryGirl.create(:type_definition, :name => 'Project_Type_3', :for_what => 'project')

      end

      context "Has 'index_global' access right for project type definition" do
          it "returns list of 3 project type definitions for a 'index_global' " do
            session[:user_id] = @ceo_u.id
            session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@ceo_u.id)
            get 'index' , {:use_route => :projectx, :for_what => 'project'}
            response.should be_success
            assigns(:type_definitions).should eq([@prj_type_def_1, @prj_type_def_2, @prj_type_def_3])
          end
        end

      context "Has 'index_global' access right for task type definition" do
        it "returns list of 1 task type definitions for a 'index_global' " do
          session[:user_id] = @ceo_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@ceo_u.id)
          get 'index' , {:use_route => :projectx, :for_what => 'task'}
          response.should be_success
          assigns(:type_definitions).should eq([@task_type_def_1])
        end
      end

    end

    describe "GET 'new'" do
      before :each do
        type_of_user = FactoryGirl.create(:group_type, :name => 'employee')
        z1 = FactoryGirl.create(:zone, :zone_name => 'hq')
        z2 = FactoryGirl.create(:zone, :zone_name => 'regional')

        sales_group_1 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => type_of_user.id, :zone_id => z1.id)
        sales_group_2 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => type_of_user.id, :zone_id => z2.id)

        new_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_type_definitions', :action => 'create')
        no_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_type_definitions', :action => 'xxxxx')

        sales_1_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => sales_group_1.id, :sys_action_on_table_id => new_access_right.id)
        sales_2_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => sales_group_2.id, :sys_action_on_table_id => no_access_right.id)

        @sales_1_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_1.id)
        @sales_2_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_2.id)

        @individual_1_u = FactoryGirl.create(:user, :name => 'name1', :login => 'login1', :email => 'name1@a.com', :user_levels => [@sales_1_ul])
        @individual_2_u = FactoryGirl.create(:user, :name => 'name2', :login => 'login2', :email => 'name2@a.com', :user_levels => [@sales_2_ul])

        @prj_type_def_1 = FactoryGirl.create(:type_definition, :name => 'Project_Type_1', :for_what => 'project')
        @task_type_def_1 = FactoryGirl.create(:type_definition, :name => 'Task_Type_1', :for_what => 'task')
      end

      context "'new' access right for project type definition" do
        it "succeed in calling new project type definition " do
          session[:user_id] = @individual_1_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_1_u.id)
          get 'new' , {:use_route => :projectx, :for_what => 'project'}
          response.should be_success
        end
        it "fail in calling new project type definition " do
          session[:user_id] = @individual_2_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_2_u.id)
          get 'new' , {:use_route => :projectx, :for_what => 'project'}
          assigns(:type_definitions).should be_blank
          response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right!")
        end
      end

      context "'new' access right for task type definition" do
        it "succeed in calling new task type definition " do
          session[:user_id] = @individual_1_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_1_u.id)
          get 'new' , {:use_route => :projectx, :for_what => 'project'}
          response.should be_success
        end
        it "fail in calling new task type definition " do
          session[:user_id] = @individual_2_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_2_u.id)
          get 'new' , {:use_route => :projectx, :for_what => 'project'}
          assigns(:type_definitions).should be_blank
          response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right!")
        end
      end

    end


    describe "GET 'create'" do
      before :each do
        type_of_user = FactoryGirl.create(:group_type, :name => 'employee')
        z1 = FactoryGirl.create(:zone, :zone_name => 'hq')
        z2 = FactoryGirl.create(:zone, :zone_name => 'regional')

        sales_group_1 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => type_of_user.id, :zone_id => z1.id)
        sales_group_2 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => type_of_user.id, :zone_id => z2.id)

        new_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_type_definitions', :action => 'create')
        no_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_type_definitions', :action => 'xxxxx')

        sales_1_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => sales_group_1.id, :sys_action_on_table_id => new_access_right.id)
        sales_2_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => sales_group_2.id, :sys_action_on_table_id => no_access_right.id)

        @sales_1_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_1.id)
        @sales_2_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_2.id)

        @individual_1_u = FactoryGirl.create(:user, :name => 'name1', :login => 'login1', :email => 'name1@a.com', :user_levels => [@sales_1_ul])
        @individual_2_u = FactoryGirl.create(:user, :name => 'name2', :login => 'login2', :email => 'name2@a.com', :user_levels => [@sales_2_ul])

        @prj_type_def_1 = FactoryGirl.create(:type_definition, :name => 'Project_Type_1', :for_what => 'project')
        @task_type_def_1 = FactoryGirl.create(:type_definition, :name => 'Task_Type_1', :for_what => 'task')
      end

      context "'create' access right for project type definition" do
        it "succeed in calling new project type definition " do
          session[:user_id] = @individual_1_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_1_u.id)
          get 'create' , {:use_route => :projectx, :for_what => 'project'}
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Type Definition Saved!")
        end
        it "fail in calling create project type definition " do
          session[:user_id] = @individual_2_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_2_u.id)
          get 'create' , {:use_route => :projectx, :for_what => 'project'}
          assigns(:type_definitions).should be_blank
          response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right!")
        end
      end

      context "'create' access right for task type definition" do
        it "succeed in calling create task type definition " do
          session[:user_id] = @individual_1_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_1_u.id)
          get 'create' , {:use_route => :projectx, :for_what => 'task'}
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Type Definition Saved!")
        end
        it "fail in calling new task type definition " do
          session[:user_id] = @individual_2_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_2_u.id)
          get 'new' , {:use_route => :projectx, :for_what => 'task'}
          assigns(:type_definitions).should be_blank
          response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right!")
        end
      end

    end


    describe "GET 'edit'" do
      before :each do
        type_of_user = FactoryGirl.create(:group_type, :name => 'employee')
        z1 = FactoryGirl.create(:zone, :zone_name => 'hq')
        z2 = FactoryGirl.create(:zone, :zone_name => 'regional')

        sales_group_1 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => type_of_user.id, :zone_id => z1.id)
        sales_group_2 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => type_of_user.id, :zone_id => z2.id)

        new_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_type_definitions', :action => 'update')
        no_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_type_definitions', :action => 'xxxxx')

        sales_1_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => sales_group_1.id, :sys_action_on_table_id => new_access_right.id)
        sales_2_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => sales_group_2.id, :sys_action_on_table_id => no_access_right.id)

        @sales_1_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_1.id)
        @sales_2_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_2.id)

        @individual_1_u = FactoryGirl.create(:user, :name => 'name1', :login => 'login1', :email => 'name1@a.com', :user_levels => [@sales_1_ul])
        @individual_2_u = FactoryGirl.create(:user, :name => 'name2', :login => 'login2', :email => 'name2@a.com', :user_levels => [@sales_2_ul])

        @prj_type_def_1 = FactoryGirl.create(:type_definition, :name => 'Project_Type_1', :for_what => 'project')
        @task_type_def_1 = FactoryGirl.create(:type_definition, :name => 'Task_Type_1', :for_what => 'task')
      end

      context "'edit' access right for project type definition" do
        it "succeed in calling edit project type definition " do
          session[:user_id] = @individual_1_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_1_u.id)
          get 'edit' , {:use_route => :projectx, :for_what => 'project'}
          response.should be_success
        end
        it "fail in calling edit project type definition " do
          session[:user_id] = @individual_2_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_2_u.id)
          get 'edit' , {:use_route => :projectx, :for_what => 'project'}
          assigns(:type_definitions).should be_blank
          response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right!")
        end
      end

      context "'edit' access right for task type definition" do
        it "succeed in calling edit task type definition " do
          session[:user_id] = @individual_1_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_1_u.id)
          get 'edit' , {:use_route => :projectx, :for_what => 'project'}
          response.should be_success
        end
        it "fail in calling edit task type definition " do
          session[:user_id] = @individual_2_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_2_u.id)
          get 'edit' , {:use_route => :projectx, :for_what => 'project'}
          assigns(:type_definitions).should be_blank
          response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right!")
        end
      end

    end

    describe "GET 'update'" do
      before :each do
        type_of_user = FactoryGirl.create(:group_type, :name => 'employee')
        z1 = FactoryGirl.create(:zone, :zone_name => 'hq')
        z2 = FactoryGirl.create(:zone, :zone_name => 'regional')

        sales_group_1 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => type_of_user.id, :zone_id => z1.id)
        sales_group_2 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => type_of_user.id, :zone_id => z2.id)

        new_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_type_definitions', :action => 'update')
        no_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_type_definitions', :action => 'xxxxx')

        sales_1_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => sales_group_1.id, :sys_action_on_table_id => new_access_right.id)
        sales_2_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => sales_group_2.id, :sys_action_on_table_id => no_access_right.id)

        @sales_1_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_1.id)
        @sales_2_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_2.id)

        @individual_1_u = FactoryGirl.create(:user, :name => 'name1', :login => 'login1', :email => 'name1@a.com', :user_levels => [@sales_1_ul])
        @individual_2_u = FactoryGirl.create(:user, :name => 'name2', :login => 'login2', :email => 'name2@a.com', :user_levels => [@sales_2_ul])

        @prj_type_def_1 = FactoryGirl.create(:type_definition, :name => 'Project_Type_1', :for_what => 'project')
        @task_type_def_1 = FactoryGirl.create(:type_definition, :name => 'Task_Type_1', :for_what => 'task')
      end

      context "should not 'update type definition'" do
        it "redirect with insufficient right for user with no sufficient rights project type definition" do
          session[:user_id] = @individual_2_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_2_u.id)
          get 'update' , {:use_route => :projectx, :for_what => 'project', :type_definition => @prj_type_def_1}
          assigns(:type_definition).should be_blank
          response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right!")
        end

        it "render edit as update action could not save project type definition " do
          session[:user_id] = @individual_1_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_1_u.id)
          get 'update' , {:use_route => :projectx, :for_what => 'project', :id => @prj_type_def_1.id, :type_definition => {:name => nil}}
          response.should render_template("edit")
        end

        it "redirect with insufficient right for user with no sufficient rights task type definition" do
          session[:user_id] = @individual_2_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_2_u.id)
          get 'update' , {:use_route => :projectx, :for_what => 'task', :type_definition => @task_type_def_1}
          assigns(:type_definition).should be_blank
          response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right!")
        end

        it "render edit as update action could not save task type definition " do
          session[:user_id] = @individual_1_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_1_u.id)
          get 'update' , {:use_route => :projectx, :for_what => 'task', :id => @task_type_def_1.id, :type_definition => {:name => nil}}
          response.should render_template("edit")
        end

      end

      context "accept 'update' with proper right" do
        it "should update project type definition for user with proper right" do
          session[:user_id] = @individual_1_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_1_u.id)
          get 'update' , {:use_route => :projectx, :for_what => 'project', :id => @prj_type_def_1.id, :project => {:name => 'new name'}}
          response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Project Type Definition Updated!")
        end

        it "should update task type definition for user with proper right" do
          session[:user_id] = @individual_1_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_1_u.id)
          get 'update' , {:use_route => :projectx, :for_what => 'task',  :id => @task_type_def_1.id, :project => {:name => 'new name'}}
          response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Task Type Definition Updated!")
        end
      end
    end

  end
end
