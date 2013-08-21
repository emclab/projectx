# encoding: utf-8
require 'spec_helper'

module Projectx
  describe TypeDefinitionsController do
    before(:each) do
      controller.should_receive(:require_signin)
    end

    render_views
    
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'type_definition_index_view', 
                              :argument_value => "This is a view") 
    end
    
    describe "GET 'index'" do
      it "returns all type" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'projectx_type_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Projectx::TypeDefinition.order('ranking_order')")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        ls = FactoryGirl.create(:type_definition, :active => true, :last_updated_by_id => @u.id)
        ls1 = FactoryGirl.create(:type_definition,:name => 'new', :active => false, :last_updated_by_id => @u.id)
        get 'index' , {:use_route => :projectx}
        assigns(:type_definitions).should eq([ls, ls1]) 
      end

    end
  
    describe "GET 'new'" do
      it "returns success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'projectx_type_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        #ls = FactoryGirl.create(:type_definition, :active => true, :last_updated_by_id => @u.id)
        get 'new' , {:use_route => :projectx}
        response.should be_success
      end
    end
  
    describe "GET 'create'" do
      it "should create successfully" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'projectx_type_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        ls = FactoryGirl.attributes_for(:type_definition, :active => true, :last_updated_by_id => @u.id)
        get 'create' , {:use_route => :projectx, :type_definition => ls}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=New Type Definition Saved!")
      end
      
      it "should render 'new' for data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'projectx_type_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        ls = FactoryGirl.attributes_for(:type_definition, :active => true, :last_updated_by_id => @u.id, :name => nil)
        get 'create' , {:use_route => :projectx, :type_definition => ls}
        response.should render_template('new')
      end
    end
  
    describe "GET 'edit'" do
      it "returns success" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'projectx_type_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        ls = FactoryGirl.create(:type_definition, :active => true, :last_updated_by_id => @u.id)
        get 'edit' , {:use_route => :projectx, :id => ls.id}
        response.should be_success
      end
    end
  
    describe "GET 'update'" do
      it "returns update" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'projectx_type_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        ls = FactoryGirl.create(:type_definition, :active => true, :last_updated_by_id => @u.id)
        get 'update' , {:use_route => :projectx, :id => ls.id, :type_definition => {:name => 'newnewone'}}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Type Definition Updated!")
      end
      
      it "should render 'edit' with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'projectx_type_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        ls = FactoryGirl.create(:type_definition, :active => true, :last_updated_by_id => @u.id)
        get 'update' , {:use_route => :projectx, :id => ls.id, :type_definition => {:name => ''}}
        response.should render_template('edit')
      end
    end
  
  end
end
