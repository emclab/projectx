namespace :db do
  desc "Seed data to run integration of our engines"
  task :integration => :environment do
    require 'factory_girl'
    #require File.dirname(__FILE__) + '/../../spec/integrationfactories.rb'
    require File.expand_path("/../../spec/factories", __FILE__)
    require File.dirname(__FILE__) + '/../../spec/factories'
    
        ceo_group = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type_of_user.id, :zone_id => z1.id)
        manager_group = FactoryGirl.create(:sys_user_group, :user_group_name => 'regional_manager', :group_type_id => type_of_user.id, :zone_id => z2.id)
        sales_group_1 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => type_of_user.id, :zone_id => z1.id)
        sales_group_2 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => type_of_user.id, :zone_id => z2.id)
        sales_group_3 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => type_of_user.id, :zone_id => z3.id)
        sales_group_4 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => type_of_user.id, :zone_id => z3.id)

        ceo_role_def = FactoryGirl.create(:role_definition, :name => "ceo", :brief_note => "ceo role")
        ceo_access_right = FactoryGirl.create(:user_access, :right => 'allow', :action => 'index', :role_definition_id => ceo_role_def.id, :resource =>'projectx_projects', :resource_type => 'table' )

        manager_role_def = FactoryGirl.create(:role_definition, :name => 'manager', :brief_note => "manager role")
        manager_access_right = FactoryGirl.create(:user_access, :right => 'allow', :action => 'index', :role_definition_id => manager_role_def.id, :resource =>'projectx_projects', :resource_type => 'record' )
        records_index_restrictions_ar = FactoryGirl.create(:restriction_detail, :user_access_id =>  manager_access_right.id, :match_against => 'Where zone_id =  ?', :values_name => 'Authentify::User.', :restriction_type => 'source')
        #regional_role_group_mapping = FactoryGirl.create(:authentify_role_group_mapping, :user_access_id => records_index_restrictions_ar.id , :sys_user_group_id => manager_group.id )

        #global_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_projects', :action => 'index')
        #regional_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_projects', :action => 'index_zone')
        #individual_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_projects', :action => 'index_individual')
        #no_individual_access_right = FactoryGirl.create(:sys_action_on_table, :table_name => 'projectx_projects', :action => 'xxxxx')

        #ceo_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ceo_group.id, :sys_action_on_table_id => global_access_right.id)
        #regional_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => regional_group.id, :sys_action_on_table_id => regional_access_right.id)
        #sales_1_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => sales_group_1.id, :sys_action_on_table_id => individual_access_right.id)
        #sales_2_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => sales_group_2.id, :sys_action_on_table_id => individual_access_right.id)
        #sales_3_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => sales_group_3.id, :sys_action_on_table_id => individual_access_right.id)
        #sales_4_ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => sales_group_4.id, :sys_action_on_table_id => no_individual_access_right.id)

        @ceo_ul       = FactoryGirl.build(:user_level, :sys_user_group_id => ceo_group.id)
        @manager_ul  = FactoryGirl.build(:user_level, :sys_user_group_id => manager_group.id)
        @sales_1_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_2.id)
        @sales_2_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_2.id)
        @sales_3_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_3.id)
        @sales_4_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_4.id)

        @ceo_user_role = FactoryGirl.create(:user_role, :role_definition_id => ceo_role_def.id)
        @ceo_u = FactoryGirl.create(:user, :name => 'ceo', :login => 'ceo111', :email => 'ceo@a.com', :user_levels => [@ceo_ul], :user_roles => [@ceo_user_role])

        @manager_user_role = FactoryGirl.create(:user_role, :role_definition_id => manager_role_def.id)
        @manager_u = FactoryGirl.create(:user, :name => 'manager', :login => 'manager', :email => 'manager@a.com', :user_levels => [@manager_ul], :user_roles => [@manager_user_role])

        sales_role_def = FactoryGirl.create(:role_definition, :name => 'sales', :brief_note => "sales role")
        sales_access_right = FactoryGirl.create(:user_access, :right => 'allow', :action => 'index', :role_definition_id => sales_role_def.id, :resource =>'projectx_projects', :resource_type => 'record' )
        #sales_restriction_access_right = FactoryGirl.create(:restriction_detail, :user_access_id => sales_access_right.id, :match_against => 'name', :restriction_type => 'group')
        sales_restriction_ar = FactoryGirl.create(:restriction_detail, :user_access_id => sales_access_right.id, :match_against => 'zone_id = ? ', :values_name => 'zone_id',:restriction_type => 'group')

        @sales_user_role = FactoryGirl.create(:user_role, :role_definition_id => sales_role_def.id)
        @individual_1_u = FactoryGirl.create(:user, :name => 'name1', :login => 'login1', :email => 'name1@a.com', :user_levels => [@sales_1_ul], :user_roles => [@sales_user_role])
        @individual_2_u = FactoryGirl.create(:user, :name => 'name2', :login => 'login2', :email => 'name2@a.com', :user_levels => [@sales_2_ul], :user_roles => [@sales_user_role])
        @individual_3_u = FactoryGirl.create(:user, :name => 'name3', :login => 'login3', :email => 'name3@a.com', :user_levels => [@sales_3_ul], :user_roles => [@sales_user_role])
        @individual_4_u = FactoryGirl.create(:user, :name => 'name4', :login => 'login4', :email => 'name4@a.com', :user_levels => [@sales_4_ul], :user_roles => [@sales_user_role])

        @prj1 = FactoryGirl.create(:project1, :zone_id => 2, :name => 'project1', :project_num => 'num1', :sales_id => @individual_1_u.id,:last_updated_by_id => @individual_1_u.id)
        @prj2 = FactoryGirl.create(:project1, :zone_id => 2, :name => 'project2', :project_num => 'num2', :sales_id => @individual_1_u.id,:last_updated_by_id => @individual_1_u.id)
        @prj3 = FactoryGirl.create(:project1, :zone_id => 1, :name => 'project3', :project_num => 'num3', :sales_id => @individual_2_u.id,:last_updated_by_id => @individual_2_u.id)
        @prj4 = FactoryGirl.create(:project1, :zone_id => 1, :name => 'project4', :project_num => 'num4', :sales_id => @individual_3_u.id,:last_updated_by_id => @individual_3_u.id)
    

  end
end
