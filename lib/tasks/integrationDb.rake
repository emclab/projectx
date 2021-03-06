namespace :db do
  desc "Seed data to run integration of our engines"
  task :integration => :environment do
    require 'factory_girl'
    #require File.dirname(__FILE__) + '/../../spec/integrationfactories.rb'
    #require File.expand_path("/spec/factories", __FILE__)
    #require File.dirname(__FILE__) + '/spec/factories'

    require File.dirname(__FILE__) + '/../../spec/factories'

      @engine_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      @type_of_user = FactoryGirl.create(:group_type, :name => 'employee')
      @z1 = FactoryGirl.create(:zone, :zone_name => 'zone1: hq')
      @z2 = FactoryGirl.create(:zone, :zone_name => 'zone2: regional')
      @z3 = FactoryGirl.create(:zone, :zone_name => 'zone3')
      @z4 = FactoryGirl.create(:zone, :zone_name => 'zone4')
      @z5 = FactoryGirl.create(:zone, :zone_name => 'zone5')



        sales_group_1 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => @type_of_user.id, :zone_id => @z1.id)
        sales_group_2 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => @type_of_user.id, :zone_id => @z2.id)
        sales_group_3 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => @type_of_user.id, :zone_id => @z3.id)
        sales_group_4 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => @type_of_user.id, :zone_id => @z4.id)
        sales_group_5 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => @type_of_user.id, :zone_id => @z5.id)

        @sales_1_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_1.id)
        @sales_2_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_2.id)
        @sales_3_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_3.id)
        @sales_4_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_4.id)
        @sales_5_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_5.id)

        sales_role_def = FactoryGirl.create(:role_definition, :name => 'sales', :brief_note => "sales role")
        sales_access_right1 = FactoryGirl.create(:user_access, :right => 'allow', :role_definition_id => sales_role_def.id, :action => 'index', :resource =>'projectx_projects', :resource_type => 'table', :sql_code => 'Projectx::Project.where(:zone_id =>  session[:user_privilege].user_zone_ids) ', :rank => 2 )
        sales_access_right2 = FactoryGirl.create(:user_access, :right => 'allow', :role_definition_id => sales_role_def.id, :action => 'index', :resource =>'projectx_projects', :resource_type => 'table', :sql_code => 'Projectx::Project.where(:zone_id =>  session[:user_privilege].user_zone_ids) ', :masked_attrs => 'project_num,=project_desp', :rank => 1 )
        sales_access_right3 = FactoryGirl.create(:user_access, :right => 'allow', :role_definition_id => sales_role_def.id, :action => 'update',:resource =>'projectx_projects', :resource_type => 'record', :sql_code => 'record.sales_id  == session[:user_id]', :rank => 1 )
        sales_access_right4 = FactoryGirl.create(:user_access, :right => 'allow', :role_definition_id => sales_role_def.id, :action => 'show',  :resource =>'projectx_projects', :resource_type => 'record', :sql_code => 'record.sales_id  == session[:user_id]', :rank => 1 )
        sales_access_right5 = FactoryGirl.create(:user_access, :right => 'allow', :role_definition_id => sales_role_def.id, :action => 'create',:resource =>'projectx_projects', :resource_type => 'record', :rank => 1 )
        sales_access_right6 = FactoryGirl.create(:user_access, :right => 'allow', :role_definition_id => sales_role_def.id, :action => 'show',  :resource =>'customerx_customers', :resource_type => 'record', :sql_code => 'record.sales_id  == session[:user_id]' )

        @sales_user_role1 = FactoryGirl.create(:user_role, :role_definition_id => sales_role_def.id)
        @sales_user_role2 = FactoryGirl.create(:user_role, :role_definition_id => sales_role_def.id)
        @sales_user_role3 = FactoryGirl.create(:user_role, :role_definition_id => sales_role_def.id)
        @sales_user_role4 = FactoryGirl.create(:user_role, :role_definition_id => sales_role_def.id)
        @sales_user_role5 = FactoryGirl.create(:user_role, :role_definition_id => sales_role_def.id)

        @individual_1_u = FactoryGirl.create(:user, :name => 'name1', :login => 'login1', :email => 'name1@a.com', :user_levels => [@sales_1_ul], :user_roles => [@sales_user_role1])
        @individual_2_u = FactoryGirl.create(:user, :name => 'name2', :login => 'login2', :email => 'name2@a.com', :user_levels => [@sales_2_ul], :user_roles => [@sales_user_role2])
        @individual_3_u = FactoryGirl.create(:user, :name => 'name3', :login => 'login3', :email => 'name3@a.com', :user_levels => [@sales_3_ul], :user_roles => [@sales_user_role3])
        @individual_4_u = FactoryGirl.create(:user, :name => 'name4', :login => 'login4', :email => 'name4@a.com', :user_levels => [@sales_4_ul], :user_roles => [@sales_user_role4])
        @individual_5_u = FactoryGirl.create(:user, :name => 'name5', :login => 'login5', :email => 'name5@a.com', :user_levels => [@sales_5_ul], :user_roles => [@sales_user_role5])

        cust1 = FactoryGirl.create(:customer, :active => true, :name => 'cust name1', :short_name => 'short name1', :zone_id => @z1.id, :last_updated_by_id => @individual_1_u.id)
        cust2 = FactoryGirl.create(:customer, :active => true, :name => 'cust name2', :short_name => 'short name2', :zone_id => @z2.id, :last_updated_by_id => @individual_2_u.id)
        cust3 = FactoryGirl.create(:customer, :active => true, :name => 'cust name3', :short_name => 'short name3', :zone_id => @z3.id, :last_updated_by_id => @individual_3_u.id)
        cust4 = FactoryGirl.create(:customer, :active => true, :name => 'cust name4', :short_name => 'short name4', :zone_id => @z4.id, :last_updated_by_id => @individual_4_u.id)
        cust5 = FactoryGirl.create(:customer, :active => true, :name => 'cust name5', :short_name => 'short name5', :zone_id => @z5.id, :last_updated_by_id => @individual_5_u.id)

        @prj1 = FactoryGirl.create(:project1, :zone_id => @z1.id, :name => 'project1', :project_desp => 'project1', :project_num => 'num1', :sales_id => @individual_1_u.id,:last_updated_by_id => @individual_1_u.id, :customer_id => cust1.id )
        @prj2 = FactoryGirl.create(:project1, :zone_id => @z2.id, :name => 'project2', :project_desp => 'project2', :project_num => 'num2', :sales_id => @individual_2_u.id,:last_updated_by_id => @individual_1_u.id, :customer_id => cust2.id )
        @prj3 = FactoryGirl.create(:project1, :zone_id => @z3.id, :name => 'project3', :project_desp => 'project3', :project_num => 'num3', :sales_id => @individual_3_u.id,:last_updated_by_id => @individual_3_u.id, :customer_id => cust3.id )
        @prj4 = FactoryGirl.create(:project1, :zone_id => @z4.id, :name => 'project4', :project_desp => 'project4', :project_num => 'num4', :sales_id => @individual_4_u.id,:last_updated_by_id => @individual_4_u.id, :customer_id => cust4.id )
        @prj5 = FactoryGirl.create(:project1, :zone_id => @z2.id, :name => 'project5', :project_desp => 'project5', :project_num => 'num5', :sales_id => @individual_5_u.id,:last_updated_by_id => @individual_5_u.id, :customer_id => cust5.id )
    

        ceo_group     = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => @type_of_user.id, :zone_id => @z1.id)
        ceo_role_def = FactoryGirl.create(:role_definition, :name => "ceo", :brief_note => "ceo role")
        ceo_access_right1 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'index', :role_definition_id => ceo_role_def.id, :resource => 'projectx_projects', :resource_type => 'table' )
        ceo_access_right2 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'update', :role_definition_id => ceo_role_def.id, :resource => 'projectx_projects', :resource_type => 'table' )
        ceo_access_right3 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'show', :role_definition_id => ceo_role_def.id, :resource => 'projectx_projects', :resource_type => 'table' )
        ceo_access_right4 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'show', :role_definition_id => ceo_role_def.id, :resource =>'customerx_customers', :resource_type => 'table' )
        ceo_access_right5 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'create', :role_definition_id => ceo_role_def.id, :resource =>'projectx_projects', :resource_type => 'table' )
        @ceo_ul       = FactoryGirl.build(:user_level, :sys_user_group_id => ceo_group.id)
        @ceo_user_role = FactoryGirl.create(:user_role, :role_definition_id => ceo_role_def.id)
        @ceo_u = FactoryGirl.create(:user, :name => 'ceo', :login => 'ceo111', :email => 'ceo@a.com', :user_levels => [@ceo_ul], :user_roles => [@ceo_user_role])

        manager_group = FactoryGirl.create(:sys_user_group, :user_group_name => 'regional_manager', :group_type_id => @type_of_user.id, :zone_id => @z2.id)
        manager_role_def = FactoryGirl.create(:role_definition, :name => 'manager', :brief_note => "manager role")
        manager_access_right1 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'index', :role_definition_id => manager_role_def.id, :resource =>'projectx_projects', :resource_type => 'table', :sql_code => 'Projectx::Project.where(:zone_id =>  session[:user_privilege].user_zone_ids) ', :rank => 2 )
        manager_access_right2 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'index', :role_definition_id => manager_role_def.id, :resource =>'projectx_projects', :resource_type => 'table', :sql_code => 'Projectx::Project.where(:zone_id =>  session[:user_privilege].user_zone_ids) ', :masked_attrs => 'project_num,=project_desp', :rank => 1 )
        manager_access_right3 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'update', :role_definition_id => manager_role_def.id, :resource =>'projectx_projects', :resource_type => 'record', :sql_code => 'record.sales_id  == session[:user_id]', :rank => 1 )
        manager_access_right4 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'show', :role_definition_id => manager_role_def.id, :resource =>'projectx_projects', :resource_type => 'record', :sql_code => 'record.sales_id  == session[:user_id]', :rank => 1 )
        manager_access_right5 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'create', :role_definition_id => manager_role_def.id, :resource =>'projectx_projects', :resource_type => 'record', :rank => 1 )
        manager_access_right6 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'show', :role_definition_id => manager_role_def.id, :resource =>'customerx_customers', :resource_type => 'record', :sql_code => 'record.sales_id  == session[:user_id]' )

        @manager_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => manager_group.id)
        @manager_user_role = FactoryGirl.create(:user_role, :role_definition_id => manager_role_def.id)
        @manager_u = FactoryGirl.create(:user, :name => 'manager', :login => 'manager', :email => 'manager@a.com', :user_levels => [@manager_ul], :user_roles => [@manager_user_role])


  end
end
