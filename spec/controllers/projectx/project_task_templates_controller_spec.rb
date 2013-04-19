#encoding: utf-8
require 'spec_helper'

module Projectx
  describe ProjectTaskTemplatesController do
    before(:each) do
      controller.should_receive(:require_signin)
    end
  
    render_views
    describe "GET 'index'" do
      before(:each) do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        @role = FactoryGirl.create(:role_definition)
        #user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'projectx_misc_definitions', :role_definition_id => role.id, :rank => 1,
        #:sql_code => "Projectx::MiscDefinition.where(:active => true).order('ranking_order')")
        ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        @proj_type = FactoryGirl.create(:type_definition)
        @proj_type1 = FactoryGirl.create(:type_definition, :name => 'newnew')
      end
      
      it "returns all templates for regular user" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'projectx_project_task_templates', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Projectx::ProjectTaskTemplate.where(:active => true).order('type_definition_id')")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:project_task_template, :active => true, :last_updated_by_id => @u.id, :type_definition_id => @proj_type.id)
        qs1 = FactoryGirl.create(:project_task_template, :active => true, :last_updated_by_id => @u.id, :type_definition_id => @proj_type1.id, :name => 'newnew')
        get 'index' , {:use_route => :projectx}
        #response.should be_success
        assigns(:project_task_templates).should eq([qs, qs1])       
      end
      
      it "should return template for the project_type" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'projectx_project_task_templates', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Projectx::ProjectTaskTemplate.where(:active => true).order('type_definition_id')")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:project_task_template, :active => true, :last_updated_by_id => @u.id, :type_definition_id => @proj_type.id)
        qs1 = FactoryGirl.create(:project_task_template, :active => true, :last_updated_by_id => @u.id, :type_definition_id => @proj_type1.id, :name => 'newnew')
        get 'index' , {:use_route => :projectx, :type_definition_id => @proj_type.id}
        #response.should be_success
        assigns(:project_task_templates).should eq([qs])
      end
      
      it "should redirect if there is no right" do
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:project_task_template, :active => true, :last_updated_by_id => @u.id)
        get 'index' , {:use_route => :projectx, :type_definition_id => @proj_type.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=index and resource=projectx/project_task_templates")
      end
    end
  
    describe "GET 'new'" do
      before(:each) do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        @role = FactoryGirl.create(:role_definition)
        ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        @proj_type = FactoryGirl.create(:type_definition)
        @proj_type1 = FactoryGirl.create(:type_definition, :name => 'newnew')
      end
      
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'projectx_project_task_templates', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'new' , {:use_route => :projectx, :type_definition_id => @proj_type.id}
        response.should be_success
      end
      
      it "should redirect if no right" do
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'new' , {:use_route => :projectx, :type_definition_id => @proj_type.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=new and resource=projectx/project_task_templates")
      end
    end
  
    describe "GET 'create'" do
      before(:each) do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        @role = FactoryGirl.create(:role_definition)
        ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        @proj_type = FactoryGirl.create(:type_definition)
        @proj_type1 = FactoryGirl.create(:type_definition, :name => 'newnew')
      end
      
      it "redirect for a successful creation" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'projectx_project_task_templates', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.attributes_for(:project_task_template)
        get 'create' , {:use_route => :projectx, :type_definition_id => @proj_type.id, :project_task_template => qs}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=项目样板已保存!")
      end
      
      it "should render 'new' if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'projectx_project_task_templates', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.attributes_for(:project_task_template, :name => nil)
        get 'create' , {:use_route => :projectx, :type_definition_id => @proj_type.id, :project_task_template => qs}
        response.should render_template("new")
      end
    end
  
    describe "GET 'edit'" do
      before(:each) do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        @role = FactoryGirl.create(:role_definition)
        ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        @proj_type = FactoryGirl.create(:type_definition)
        @proj_type1 = FactoryGirl.create(:type_definition, :name => 'newnew')
      end
      
      it "returns http success for edit" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'projectx_project_task_templates', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:project_task_template)
        get 'edit' , {:use_route => :projectx, :type_definition_id => @proj_type.id, :id => qs.id}
        response.should be_success
      end
      
      it "should redirect if no right" do
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:project_task_template)
        get 'edit' , {:use_route => :projectx, :type_definition_id => @proj_type.id, :id => qs.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=edit and resource=projectx/project_task_templates")
      end
    end
  
    describe "GET 'update'" do
      before(:each) do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        @role = FactoryGirl.create(:role_definition)
        ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        @proj_type = FactoryGirl.create(:type_definition)
        @proj_type1 = FactoryGirl.create(:type_definition, :name => 'newnew')
      end
      
      it "redirect if success" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'projectx_project_task_templates', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:project_task_template)
        get 'update' , {:use_route => :projectx, :type_definition_id => @proj_type.id, :id => qs.id, :project_task_template => {:name => 'newnew'}}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=项目样板已更新!")
      end
      
      it "should render 'new' if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'projectx_project_task_templates', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:project_task_template)
        get 'update' , {:use_route => :projectx, :type_definition_id => @proj_type.id, :id => qs.id, :project_task_template => {:name => nil}}
        response.should render_template("edit")
      end
    end
  
    describe "GET 'show'" do
      before(:each) do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        @role = FactoryGirl.create(:role_definition)
        ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        @proj_type = FactoryGirl.create(:type_definition)
        @proj_type1 = FactoryGirl.create(:type_definition, :name => 'newnew')
      end
         
      it "should show" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource => 'projectx_project_task_templates', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:project_task_template)
        get 'show' , {:use_route => :projectx, :type_definition_id => @proj_type.id, :id => qs.id}
        response.should be_success
      end
    end
  
  end
end
