require 'spec_helper'

module Projectx
  describe ProjectsController do

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

        global_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_projects', :action => 'index')
        regional_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_projects', :action => 'index_zone')
        individual_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_projects', :action => 'index_individual')
        no_individual_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_projects', :action => 'xxxxx')

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

        @prj1 = FactoryGirl.create(:project1, :zone_id => 2, :name => 'project1', :project_num => 'num1', :sales_id => @individual_1_u.id,:last_updated_by_id => @individual_1_u.id)
        @prj2 = FactoryGirl.create(:project1, :zone_id => 2, :name => 'project2', :project_num => 'num2', :sales_id => @individual_1_u.id,:last_updated_by_id => @individual_1_u.id)
        @prj3 = FactoryGirl.create(:project1, :zone_id => 1, :name => 'project3', :project_num => 'num3', :sales_id => @individual_2_u.id,:last_updated_by_id => @individual_2_u.id)
        @prj4 = FactoryGirl.create(:project1, :zone_id => 1, :name => 'project4', :project_num => 'num4', :sales_id => @individual_3_u.id,:last_updated_by_id => @individual_3_u.id)
      end

      context "Has global 'index' access right " do
        it "returns projects list " do
          session[:user_id] = @ceo_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@ceo_u.id)
          get 'index' , {:use_route => :projectx}
          assigns(:projects).should eq([@prj4, @prj3, @prj2, @prj1])
        end
      end

      context "Has regional 'index' access right " do
        it "returns projects list " do
          session[:user_id] = @regional_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@regional_u.id)
          get 'index' , {:use_route => :projectx}
          assigns(:projects).should eq([@prj2, @prj1])
        end
      end

      context "Has individual 'index' access right " do
        it "returns projects list for this individual user" do
          session[:user_id] = @individual_1_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_1_u.id)
          get 'index' , {:use_route => :projectx}
          assigns(:projects).should eq([@prj2, @prj1])
        end

        it "returns projects list for this individual user" do
          session[:user_id] = @individual_2_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_2_u.id)
          get 'index' , {:use_route => :projectx}
          assigns(:projects).should eq([@prj3])
        end

        it "returns projects list for this individual user" do
          session[:user_id] = @individual_3_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_3_u.id)
          get 'index' , {:use_route => :projectx}
          assigns(:projects).should eq([@prj4])
        end
      end

      context "Has no 'index' access right " do
        it "returns an empty list " do
          session[:user_id] = @individual_4_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_4_u.id)
          get 'index' , {:use_route => :projectx}
          assigns(:projects).should be_blank
          response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right!")
        end
      end
    end
    
    describe "GET new" do
      before :each do
        type_of_user = FactoryGirl.create(:group_type, :name => 'employee')
        z1 = FactoryGirl.create(:zone, :zone_name => 'hq')
        sales_group_1 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => type_of_user.id, :zone_id => z1.id)
        sales_group_2 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales2', :group_type_id => type_of_user.id, :zone_id => z1.id)

        new_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_projects', :action => 'create')
        no_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_projects', :action => 'xxxxx')

        sales_new_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => sales_group_1.id, :sys_action_on_table_id => new_access_right.id)
        sales_no_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => sales_group_2.id, :sys_action_on_table_id => no_access_right.id)

        @sales_new_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_1.id)
        @sales_no_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_2.id)
        @new_u = FactoryGirl.create(:user, :name => 'name1', :login => 'login1', :email => 'name1@a.com', :user_levels => [@sales_new_ul])
        @no_u = FactoryGirl.create(:user, :name => 'name2', :login => 'login2', :email => 'name2@a.com', :user_levels => [@sales_no_ul])
      end

      context "reject 'new project' without proper right" do
        it "redirect with insufficient right " do
          session[:user_id] = @no_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@no_u.id)
          get 'new' , {:use_route => :projectx}
          assigns(:projects).should be_blank
          response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right!")
        end
      end

      context "accept 'new project' with proper right" do
        it "should new for user with proper right" do
          session[:user_id] = @no_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@new_u.id)
          get 'new' , {:use_route => :projectx}
          response.should be_success
        end
      end
    end
    
    describe "GET Create" do
      before :each do
        type_of_user = FactoryGirl.create(:group_type, :name => 'employee')
        z1 = FactoryGirl.create(:zone, :zone_name => 'hq')
        sales_group_1 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => type_of_user.id, :zone_id => z1.id)
        sales_group_2 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales2', :group_type_id => type_of_user.id, :zone_id => z1.id)

        new_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_projects', :action => 'create')
        no_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_projects', :action => 'xxxxx')

        sales_new_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => sales_group_1.id, :sys_action_on_table_id => new_access_right.id)
        sales_no_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => sales_group_2.id, :sys_action_on_table_id => no_access_right.id)

        @sales_new_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_1.id)
        @sales_no_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_2.id)
        @new_u = FactoryGirl.create(:user, :name => 'name1', :login => 'login1', :email => 'name1@a.com', :user_levels => [@sales_new_ul])
        @no_u = FactoryGirl.create(:user, :name => 'name2', :login => 'login2', :email => 'name2@a.com', :user_levels => [@sales_no_ul])

        @new_prj = FactoryGirl.attributes_for(:project1, :name => 'project1', :project_num => 'num1', :sales_id => @new_u.id,:last_updated_by_id => @new_u.id)
        @bad_prj = FactoryGirl.attributes_for(:project1, :name => nil, :project_num => nil, :sales_id => @new_u.id,:last_updated_by_id => @new_u.id)
      end

      context "should not 'create project'" do
        it "redirect with insufficient right for user with no sufficient rights" do
          session[:user_id] = @no_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@no_u.id)
          get 'create' , {:use_route => :projectx, :project => @new_prj}
          assigns(:projects).should be_blank
          response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right!")
        end

        it "render new when not able to save " do
          session[:user_id] = @no_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@new_u.id)
          get 'create' , {:use_route => :projectx, :project => @bad_prj}
          assigns(:projects).should be_blank
          response.should render_template("new")
        end
      end

      context "accept 'create project' with proper right" do
        it "should create project for user with proper right" do
          session[:user_id] = @no_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@new_u.id)
          get 'create' , {:use_route => :projectx, :project => @new_prj}
          response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Project Saved!")
        end
      end
    end
    
    describe "GET Edit" do
      before :each do
        type_of_user = FactoryGirl.create(:group_type, :name => 'employee')
        z1 = FactoryGirl.create(:zone, :zone_name => 'hq')
        sales_group_1 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => type_of_user.id, :zone_id => z1.id)
        sales_group_2 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales2', :group_type_id => type_of_user.id, :zone_id => z1.id)

        new_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_projects', :action => 'update')
        no_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_projects', :action => 'xxxxx')

        sales_new_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => sales_group_1.id, :sys_action_on_table_id => new_access_right.id)
        sales_no_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => sales_group_2.id, :sys_action_on_table_id => no_access_right.id)

        @sales_new_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_1.id)
        @sales_no_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_2.id)
        @new_u = FactoryGirl.create(:user, :name => 'name1', :login => 'login1', :email => 'name1@a.com', :user_levels => [@sales_new_ul])
        @no_u = FactoryGirl.create(:user, :name => 'name2', :login => 'login2', :email => 'name2@a.com', :user_levels => [@sales_no_ul])

        @new_prj = FactoryGirl.create(:project1, :name => 'project1', :project_num => 'num1', :sales_id => @new_u.id,:last_updated_by_id => @new_u.id)
        @bad_prj = FactoryGirl.attributes_for(:project1, :name => nil, :project_num => nil, :sales_id => @new_u.id,:last_updated_by_id => @new_u.id)
      end

      context "should not 'edit project'" do
        it "redirect with insufficient right for user with no sufficient rights" do
          session[:user_id] = @no_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@no_u.id)
          get 'edit' , {:use_route => :projectx, :id => @new_prj.id}
          response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right!")
        end
      end

      context "accept 'edit project' with proper right" do
        it "should new for user with proper right" do
          session[:user_id] = @no_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@new_u.id)
          get 'edit' , {:use_route => :projectx, :id => @new_prj.id}
          response.should be_success
        end
      end

    end
    
    describe "GET Update" do
      before :each do
        type_of_user = FactoryGirl.create(:group_type, :name => 'employee')
        z1 = FactoryGirl.create(:zone, :zone_name => 'hq')
        sales_group_1 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => type_of_user.id, :zone_id => z1.id)
        sales_group_2 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales2', :group_type_id => type_of_user.id, :zone_id => z1.id)

        new_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_projects', :action => 'update')
        no_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_projects', :action => 'xxxxx')

        sales_new_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => sales_group_1.id, :sys_action_on_table_id => new_access_right.id)
        sales_no_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => sales_group_2.id, :sys_action_on_table_id => no_access_right.id)

        @sales_new_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_1.id)
        @sales_no_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_2.id)
        @new_u = FactoryGirl.create(:user, :name => 'name1', :login => 'login1', :email => 'name1@a.com', :user_levels => [@sales_new_ul])
        @no_u = FactoryGirl.create(:user, :name => 'name2', :login => 'login2', :email => 'name2@a.com', :user_levels => [@sales_no_ul])

        @new_prj = FactoryGirl.create(:project1, :name => 'project1', :project_num => 'num1', :sales_id => @new_u.id,:last_updated_by_id => @new_u.id)
        @bad_prj = FactoryGirl.attributes_for(:project1, :name => nil, :project_num => nil, :sales_id => @new_u.id,:last_updated_by_id => @new_u.id)
      end

      context "should not 'update project'" do
        it "redirect with insufficient right for user with no sufficient rights" do
          session[:user_id] = @no_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@no_u.id)
          get 'update' , {:use_route => :projectx, :project => @new_prj}
          assigns(:projects).should be_blank
          response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right!")
        end

        it "render edit as update action could not save project " do
          session[:user_id] = @new_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@new_u.id)
          get 'update' , {:use_route => :projectx, :id => @new_prj.id, :project => {:name => nil}}
          assigns(:projects).should be_blank
          response.should render_template("edit")
        end
      end

      context "accept 'update project' with proper right" do
        it "should update project for user with proper right" do
          session[:user_id] = @new_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@new_u.id)
          get 'update' , {:use_route => :projectx, :id => @new_prj.id, :project => {:name => 'new name'}}
          response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Project Update Saved!")
        end
      end
    end

    describe "GET show" do
      before :each do
        type_of_user = FactoryGirl.create(:group_type, :name => 'employee')
        z1 = FactoryGirl.create(:zone, :zone_name => 'hq')
        sales_group_1 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => type_of_user.id, :zone_id => z1.id)
        sales_group_2 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales2', :group_type_id => type_of_user.id, :zone_id => z1.id)

        new_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_projects', :action => 'show')
        no_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_projects', :action => 'xxxxx')

        sales_new_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => sales_group_1.id, :sys_action_on_table_id => new_access_right.id)
        sales_no_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => sales_group_2.id, :sys_action_on_table_id => no_access_right.id)

        @sales_new_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_1.id)
        @sales_no_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_2.id)
        @new_u = FactoryGirl.create(:user, :name => 'name1', :login => 'login1', :email => 'name1@a.com', :user_levels => [@sales_new_ul])
        @no_u = FactoryGirl.create(:user, :name => 'name2', :login => 'login2', :email => 'name2@a.com', :user_levels => [@sales_no_ul])
        customer = FactoryGirl.create(:customer1)
        @new_prj = FactoryGirl.create(:project1, :name => 'project1', :project_num => 'num1', :sales_id => @new_u.id,:last_updated_by_id => @new_u.id)
        @bad_prj = FactoryGirl.attributes_for(:project1, :name => nil, :project_num => nil, :sales_id => @new_u.id,:last_updated_by_id => @new_u.id)
      end

      context "should not 'show project'" do
        it "redirect with insufficient right for user with no sufficient rights" do
          session[:user_id] = @no_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@no_u.id)
          get 'show' , {:use_route => :projectx, :id => @new_prj.id}
          response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right!")
        end
      end

      context "should show projects for user with proper right" do
        it "shows projects" do
          session[:user_id] = @new_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@new_u.id)
          get 'show' , {:use_route => :projectx, :id => @new_prj.id}
          response.should be_success
        end
      end

    end
    
    describe "GET search" do
      before :each do
        type_of_user = FactoryGirl.create(:group_type, :name => 'employee')
        z1 = FactoryGirl.create(:zone, :zone_name => 'hq')
        sales_group_1 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => type_of_user.id, :zone_id => z1.id)
        sales_group_2 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales2', :group_type_id => type_of_user.id, :zone_id => z1.id)

        new_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_projects', :action => 'search_individual')
        no_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_projects', :action => 'xxxxx')

        sales_new_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => sales_group_1.id, :sys_action_on_table_id => new_access_right.id)
        sales_no_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => sales_group_2.id, :sys_action_on_table_id => no_access_right.id)

        @sales_new_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_1.id)
        @sales_no_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_2.id)
        @new_u = FactoryGirl.create(:user, :name => 'name1', :login => 'login1', :email => 'name1@a.com', :user_levels => [@sales_new_ul])
        @no_u = FactoryGirl.create(:user, :name => 'name2', :login => 'login2', :email => 'name2@a.com', :user_levels => [@sales_no_ul])

        @new_prj = FactoryGirl.create(:project1, :name => 'project1', :project_num => 'num1', :sales_id => @new_u.id,:last_updated_by_id => @new_u.id)
        @bad_prj = FactoryGirl.attributes_for(:project1, :name => nil, :project_num => nil, :sales_id => @new_u.id,:last_updated_by_id => @new_u.id)
      end

      context "should not 'search project'" do
        it "redirect with insufficient right for user with no sufficient rights" do
          session[:user_id] = @no_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@no_u.id)
          get 'show' , {:use_route => :projectx, :id => @new_prj.id}
          response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right!")
        end
      end

      context "should search projects for user with proper right" do
        it "search projects" do
          session[:user_id] = @new_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@new_u.id)
          get 'search' , {:use_route => :projectx}
          response.should be_success
        end
      end

    end
  end

end
