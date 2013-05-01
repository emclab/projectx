require 'spec_helper'

module Projectx
  describe PaymentsController do

    before(:each) do
      controller.should_receive(:require_signin)
      controller.should_receive(:require_employee)

      @project_num_time_gen = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'project_num_time_gen', :argument_value => ' Projectx::Project.last.nil? ? (Time.now.strftime("%Y%m%d") + "-"  + 112233.to_s + "-" + rand(100..999).to_s) :  (Time.now.strftime("%Y%m%d") + "-"  + (Projectx::Project.last.project_num.split("-")[-2].to_i + 555).to_s + "-" + rand(100..999).to_s)')
      @project_has_sales_config = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'project_has_sales', :argument_value => 'true')
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'payment_terms', :argument_value => '0,10, 15, 30, 60, 75, 90')
      @payment_type = FactoryGirl.create(:engine_config, :engine_name => 'projectx', :engine_version => nil, :argument_name => 'payment_type', :argument_value => 'Cash, Check, Coupon, Credit Card, Credit Letter')

      @type_of_user = FactoryGirl.create(:group_type, :name => 'employee')
      @project_type1 = FactoryGirl.create(:type_definition, :name => 'type1', :active=> true, :brief_note => 'looking for a new type')
      @project_task_template1 = FactoryGirl.create(:project_task_template, :name => 'template1', :type_definition_id => @project_type1.id )
      @project_status1 = FactoryGirl.create(:misc_definition, :name => 'started', :for_which => 'project_status' )

      @z1 = FactoryGirl.create(:zone, :zone_name => 'zone1: hq')
      @z2 = FactoryGirl.create(:zone, :zone_name => 'zone2: regional')
      @z3 = FactoryGirl.create(:zone, :zone_name => 'zone3')
      @z4 = FactoryGirl.create(:zone, :zone_name => 'zone4')
      @z5 = FactoryGirl.create(:zone, :zone_name => 'zone5')
    end

    render_views

    describe "GET 'index'" do
      before :each do
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
        sales_access_right1 = FactoryGirl.create(:user_access, :right => 'allow', :role_definition_id => sales_role_def.id, :action => 'index', :resource =>'projectx_payments', :resource_type => 'table', :sql_code => 'Projectx::Payment.joins(:contract => {:project => :customer}).where(:customerx_customers => {:zone_id => session[:user_privilege].user_zone_ids})', :rank => 2 )
        sales_access_right2 = FactoryGirl.create(:user_access, :right => 'allow', :role_definition_id => sales_role_def.id, :action => 'index', :resource =>'projectx_payments', :resource_type => 'table', :sql_code => 'Projectx::Payment.joins(:contract => {:project => :customer}).where(:customerx_customers => {:zone_id => session[:user_privilege].user_zone_ids})', :masked_attrs => 'project_num,=project_desp', :rank => 1 )
        sales_access_right3 = FactoryGirl.create(:user_access, :right => 'allow', :role_definition_id => sales_role_def.id, :action => 'update',:resource =>'projectx_payments', :resource_type => 'record', :sql_code => 'record.contract.project.sales_id  == session[:user_id]', :rank => 1 )
        sales_access_right4 = FactoryGirl.create(:user_access, :right => 'allow', :role_definition_id => sales_role_def.id, :action => 'show',  :resource =>'projectx_payments', :resource_type => 'record', :sql_code => 'record.contract.project.sales_id  == session[:user_id]', :rank => 1 )
        sales_access_right5 = FactoryGirl.create(:user_access, :right => 'allow', :role_definition_id => sales_role_def.id, :action => 'create',:resource =>'projectx_payments', :resource_type => 'record', :rank => 1 )
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

        @cust1 = FactoryGirl.create(:customer, :active => true, :name => 'cust name1', :short_name => 'short name1', :zone_id => @z1.id, :last_updated_by_id => @individual_1_u.id)
        @cust2 = FactoryGirl.create(:customer, :active => true, :name => 'cust name2', :short_name => 'short name2', :zone_id => @z2.id, :last_updated_by_id => @individual_2_u.id)
        @cust3 = FactoryGirl.create(:customer, :active => true, :name => 'cust name3', :short_name => 'short name3', :zone_id => @z3.id, :last_updated_by_id => @individual_3_u.id)
        @cust4 = FactoryGirl.create(:customer, :active => true, :name => 'cust name4', :short_name => 'short name4', :zone_id => @z4.id, :last_updated_by_id => @individual_4_u.id)
        @cust5 = FactoryGirl.create(:customer, :active => true, :name => 'cust name5', :short_name => 'short name5', :zone_id => @z5.id, :last_updated_by_id => @individual_5_u.id)

        @paymnt1 = FactoryGirl.build(:payment, :paid_amount => 101.10, :received_by_id => @individual_1_u.id, :payment_type => 'Check', :received_date => '2013/04/25')
        @paymnt2 = FactoryGirl.build(:payment, :paid_amount => 201.10, :received_by_id => @individual_2_u.id, :payment_type => 'Cash', :received_date => '2013/04/25')
        @paymnt3 = FactoryGirl.build(:payment, :paid_amount => 301.10, :received_by_id => @individual_3_u.id, :payment_type => 'Credit Card', :received_date => '2013/04/25')
        @paymnt4 = FactoryGirl.build(:payment, :paid_amount => 401.10, :received_by_id => @individual_4_u.id, :payment_type => 'Check', :received_date => '2013/04/25')
        @paymnt5 = FactoryGirl.build(:payment, :paid_amount => 501.10, :received_by_id => @individual_2_u.id, :payment_type => 'Check', :received_date => '2013/04/25')


        @contract1 = FactoryGirl.build(:contract, :payment => @paymnt1)
        @contract2 = FactoryGirl.build(:contract, :payment => @paymnt2)
        @contract3 = FactoryGirl.build(:contract, :payment => @paymnt3)
        @contract4 = FactoryGirl.build(:contract, :payment => @paymnt4)
        @contract5 = FactoryGirl.build(:contract, :payment => @paymnt5)

        @prj1 = FactoryGirl.create(:project, :name => 'project1', :project_desp => 'project1', :sales_id => @individual_1_u.id,:last_updated_by_id => @individual_1_u.id, :customer_id => @cust1.id, :project_task_template_id => @project_task_template1.id, :contract => @contract1)
        @prj2 = FactoryGirl.create(:project, :name => 'project2', :project_desp => 'project2', :sales_id => @individual_2_u.id,:last_updated_by_id => @individual_1_u.id, :customer_id => @cust2.id, :project_task_template_id => @project_task_template1.id, :contract => @contract2)
        @prj3 = FactoryGirl.create(:project, :name => 'project3', :project_desp => 'project3', :sales_id => @individual_3_u.id,:last_updated_by_id => @individual_3_u.id, :customer_id => @cust3.id, :project_task_template_id => @project_task_template1.id, :contract => @contract3)
        @prj4 = FactoryGirl.create(:project, :name => 'project4', :project_desp => 'project4', :sales_id => @individual_4_u.id,:last_updated_by_id => @individual_4_u.id, :customer_id => @cust4.id, :project_task_template_id => @project_task_template1.id, :contract => @contract4)
        @prj5 = FactoryGirl.create(:project, :name => 'project5', :project_desp => 'project5', :sales_id => @individual_2_u.id,:last_updated_by_id => @individual_5_u.id, :customer_id => @cust2.id, :project_task_template_id => @project_task_template1.id, :contract => @contract5)


      end

      context "Has individual 'index' access right" do

        it "returns contracts list for this individual user" do
          session[:user_id] = @individual_3_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_3_u)
          get 'index' , {:use_route => :projectx}
          assigns(:payments).should =~ [@paymnt3]
        end

        it "returns projects list for this individual user" do
          session[:user_id] = @individual_2_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_2_u)
          get 'index' , {:use_route => :projectx}
          assigns(:payments).should =~ [@paymnt2, @paymnt5]
        end
      end

      context "Has global 'index' access right " do
        before :each do
          ceo_group     = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => @type_of_user.id, :zone_id => @z1.id)
          ceo_role_def = FactoryGirl.create(:role_definition, :name => "ceo", :brief_note => "ceo role")

          ceo_access_right1 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'index', :role_definition_id => ceo_role_def.id, :resource => 'projectx_payments', :resource_type => 'table' )
          ceo_access_right2 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'update', :role_definition_id => ceo_role_def.id, :resource => 'projectx_payments', :resource_type => 'table' )
          ceo_access_right3 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'show', :role_definition_id => ceo_role_def.id, :resource => 'projectx_payments', :resource_type => 'table' )
          ceo_access_right4 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'show', :role_definition_id => ceo_role_def.id, :resource =>'customerx_customers', :resource_type => 'table' )
          ceo_access_right5 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'create', :role_definition_id => ceo_role_def.id, :resource =>'projectx_payments', :resource_type => 'table' )

          @ceo_ul       = FactoryGirl.build(:user_level, :sys_user_group_id => ceo_group.id)
          @ceo_user_role = FactoryGirl.create(:user_role, :role_definition_id => ceo_role_def.id)
          @ceo_u = FactoryGirl.create(:user, :name => 'ceo', :login => 'ceo111', :email => 'ceo@a.com', :user_levels => [@ceo_ul], :user_roles => [@ceo_user_role])
        end

        it "returns projects list " do
          session[:user_id] = @ceo_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@ceo_u)
          get 'index' , {:use_route => :projectx}
          assigns(:payments).should =~ [@paymnt1, @paymnt2, @paymnt3, @paymnt4, @paymnt5]
        end
      end

      context "Has only records 'index' access right " do
        before :each do
          manager_group = FactoryGirl.create(:sys_user_group, :user_group_name => 'regional_manager', :group_type_id => @type_of_user.id, :zone_id => @z2.id)
          manager_role_def = FactoryGirl.create(:role_definition, :name => 'manager', :brief_note => "manager role")
          manager_access_right1 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'index', :role_definition_id => manager_role_def.id, :resource =>'projectx_payments', :resource_type => 'table', :sql_code => 'Projectx::Payment.joins(:contract => {:project => :customer}).where(:customerx_customers => {:zone_id => session[:user_privilege].user_zone_ids})', :rank => 2 )
          manager_access_right2 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'index', :role_definition_id => manager_role_def.id, :resource =>'projectx_payments', :resource_type => 'table', :sql_code => 'Projectx::Payment.joins(:contract => {:project => :customer}).where(:customerx_customers => {:zone_id => session[:user_privilege].user_zone_ids})', :masked_attrs => 'project_num,=project_desp', :rank => 1 )
          manager_access_right3 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'update', :role_definition_id => manager_role_def.id, :resource =>'projectx_payments', :resource_type => 'record', :sql_code => 'record.contract.project.sales_id  == session[:user_id]', :rank => 1 )
          manager_access_right4 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'show', :role_definition_id => manager_role_def.id, :resource =>'projectx_payments', :resource_type => 'record', :sql_code => 'record.contract.project.sales_id  == session[:user_id]', :rank => 1 )
          manager_access_right5 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'create', :role_definition_id => manager_role_def.id, :resource =>'projectx_payments', :resource_type => 'record', :rank => 1 )
          manager_access_right6 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'show', :role_definition_id => manager_role_def.id, :resource =>'customerx_customers', :resource_type => 'record', :sql_code => 'record.sales_id  == session[:user_id]' )

          @manager_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => manager_group.id)
          @manager_user_role = FactoryGirl.create(:user_role, :role_definition_id => manager_role_def.id)
          @manager_u = FactoryGirl.create(:user, :name => 'manager', :login => 'manager', :email => 'manager@a.com', :user_levels => [@manager_ul], :user_roles => [@manager_user_role])

        end

        it "returns projects list " do
          session[:user_id] = @manager_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@manager_u)
          get 'index' , {:use_route => :projectx}
          assigns(:payments).should =~ [@paymnt2, @paymnt5]
        end
      end

      context "Has no 'index' access right " do
        before :each do
          sales_group_6 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => @type_of_user.id, :zone_id => @z5.id)
          @sales_6_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_6.id)

          sales_role_def2 = FactoryGirl.create(:role_definition, :name => 'sales2', :brief_note => "sales role")
          sales_access_right6 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'show', :role_definition_id => sales_role_def2.id, :resource =>'customerx_customers', :resource_type => 'record', :sql_code => 'Projectx::Payment.joins(:contract => :project => :customer).where(:customerx_customers => {:zone_id => session[:user_privilege].user_zone_ids})', :rank => 1 )

          @sales_user_role6 = FactoryGirl.create(:user_role, :role_definition_id => sales_role_def2.id)
          @individual_6_u = FactoryGirl.create(:user, :name => 'name6', :login => 'login6', :email => 'name6@a.com', :user_levels => [@sales_6_ul], :user_roles => [@sales_user_role6])
        end

        it "returns an empty list " do
          session[:user_id] = @individual_6_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_6_u)
          get 'index' , {:use_route => :projectx}
          assigns(:payments).should be_blank
          response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=index and resource=projectx/payments")
        end
      end

    end

    describe "GET new" do
      context "Has no access right for 'new' project " do
        before :each do
          sales_group_6 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => @type_of_user.id, :zone_id => @z5.id)
          @sales_6_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_6.id)

          sales_role_def2 = FactoryGirl.create(:role_definition, :name => 'sales2', :brief_note => "sales role")
          sales_access_right6 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'show', :role_definition_id => sales_role_def2.id, :resource =>'customerx_customers', :resource_type => 'record', :sql_code => 'Projectx::Payment.joins(:contract => :project => :customer).where(:customerx_customers => {:zone_id => session[:user_privilege].user_zone_ids})', :rank => 1 )

          @sales_user_role6 = FactoryGirl.create(:user_role, :role_definition_id => sales_role_def2.id)
          @individual_6_u = FactoryGirl.create(:user, :name => 'name6', :login => 'login6', :email => 'name6@a.com', :user_levels => [@sales_6_ul], :user_roles => [@sales_user_role6])
        end

        it "redirect with insufficient right " do
          session[:user_id] = @individual_6_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_6_u)
          get 'new' , {:use_route => :projectx}
          assigns(:payments).should be_blank
          response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=new and resource=projectx/payments")
        end
      end

      context "Has access right for 'new' project" do
        before :each do
          sales_role_def = FactoryGirl.create(:role_definition, :name => 'sales', :brief_note => "sales role")
          sales_access_right1 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'create', :role_definition_id => sales_role_def.id, :resource =>'projectx_payments', :resource_type => 'record', :rank => 1 )

          sales_group_3 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => @type_of_user.id, :zone_id => @z3.id)
          @sales_3_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_3.id)
          @sales_user_role3 = FactoryGirl.create(:user_role, :role_definition_id => sales_role_def.id)
          @individual_7_u = FactoryGirl.create(:user, :name => 'name7', :login => 'login7', :email => 'name7@a.com', :user_levels => [@sales_3_ul], :user_roles => [@sales_user_role3])

          cust3 = FactoryGirl.create(:customer, :active => true, :name => 'cust name3', :short_name => 'short name3', :zone_id => @z3.id, :last_updated_by_id => @individual_7_u.id)
          cust4 = FactoryGirl.create(:customer, :active => true, :name => 'cust name4', :short_name => 'short name4', :zone_id => @z3.id, :last_updated_by_id => @individual_7_u.id)

          @prj3 = FactoryGirl.create(:project, :name => 'project3', :project_desp => 'project3', :sales_id => @individual_7_u.id,:last_updated_by_id => @individual_7_u.id, :customer_id => cust3.id, :project_task_template_id => @project_task_template1.id)
          @contract3 = FactoryGirl.create(:contract, :project_id => @prj3.id)


        end

        it "should allow for new project with proper right" do
          session[:user_id] = @individual_7_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_7_u.id)
          get 'new' , {:use_route => :projectx, :contract_id => @contract3.id}
          response.should be_success
        end
      end
    end

    describe "GET Create" do
      context "Has no access right for 'create' project " do
        before :each do
          sales_group_6 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => @type_of_user.id, :zone_id => @z5.id)
          @sales_6_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_6.id)

          sales_role_def2 = FactoryGirl.create(:role_definition, :name => 'sales2', :brief_note => "sales role")
          sales_access_right6 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'show', :role_definition_id => sales_role_def2.id, :resource =>'customerx_customers', :resource_type => 'record', :sql_code => 'Projectx::Payment.joins(:contract => :project => :customer).where(:customerx_customers => {:zone_id => session[:user_privilege].user_zone_ids})', :rank => 1 )

          @sales_user_role6 = FactoryGirl.create(:user_role, :role_definition_id => sales_role_def2.id)
          @individual_6_u = FactoryGirl.create(:user, :name => 'name6', :login => 'login6', :email => 'name6@a.com', :user_levels => [@sales_6_ul], :user_roles => [@sales_user_role6])
        end

        it "redirect with insufficient right " do
          session[:user_id] = @individual_6_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_6_u)
          get 'create' , {:use_route => :projectx}
          assigns(:payments).should be_blank
          response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=create and resource=projectx/payments")
        end

      end

      context "Has access right for 'create' project" do
        before :each do
          sales_role_def = FactoryGirl.create(:role_definition, :name => 'sales', :brief_note => "sales role")
          sales_access_right1 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'create', :role_definition_id => sales_role_def.id, :resource =>'projectx_payments', :resource_type => 'record', :rank => 1 )

          sales_group_3 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => @type_of_user.id, :zone_id => @z3.id)
          @sales_3_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_3.id)
          @sales_user_role3 = FactoryGirl.create(:user_role, :role_definition_id => sales_role_def.id)
          @individual_7_u = FactoryGirl.create(:user, :name => 'name7', :login => 'login7', :email => 'name7@a.com', :user_levels => [@sales_3_ul], :user_roles => [@sales_user_role3])

          cust3 = FactoryGirl.create(:customer, :active => true, :name => 'cust name3', :short_name => 'short name3', :zone_id => @z3.id, :last_updated_by_id => @individual_7_u.id)
          cust4 = FactoryGirl.create(:customer, :active => true, :name => 'cust name4', :short_name => 'short name4', :zone_id => @z3.id, :last_updated_by_id => @individual_7_u.id)
          cust5 = FactoryGirl.create(:customer, :active => true, :name => 'cust name5', :short_name => 'short name5', :zone_id => @z3.id, :last_updated_by_id => @individual_7_u.id)
        end

        it "should allow to create project with proper right" do
          session[:user_id] = @individual_7_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_7_u.id)
          get 'create' , {:use_route => :projectx}
          response.should be_success
        end
      end
    end

    describe "GET Edit" do
      before :each do
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
        sales_access_right1 = FactoryGirl.create(:user_access, :right => 'allow', :role_definition_id => sales_role_def.id, :action => 'index', :resource =>'projectx_payments', :resource_type => 'table', :sql_code => 'Projectx::Payment.joins(:contract => :project => :customer).where(:customerx_customers => {:zone_id => session[:user_privilege].user_zone_ids})', :rank => 2 )
        sales_access_right2 = FactoryGirl.create(:user_access, :right => 'allow', :role_definition_id => sales_role_def.id, :action => 'index', :resource =>'projectx_payments', :resource_type => 'table', :sql_code => 'Projectx::Payment.joins(:contract => :project => :customer).where(:customerx_customers => {:zone_id => session[:user_privilege].user_zone_ids})', :masked_attrs => 'project_num,=project_desp', :rank => 1 )
        sales_access_right3 = FactoryGirl.create(:user_access, :right => 'allow', :role_definition_id => sales_role_def.id, :action => 'update',:resource =>'projectx_payments', :resource_type => 'record', :sql_code => 'record.contract.project.sales_id  == session[:user_id]', :rank => 1 )
        sales_access_right4 = FactoryGirl.create(:user_access, :right => 'allow', :role_definition_id => sales_role_def.id, :action => 'show',  :resource =>'projectx_payments', :resource_type => 'record', :sql_code => 'record.contract.project.sales_id  == session[:user_id]', :rank => 1 )
        sales_access_right5 = FactoryGirl.create(:user_access, :right => 'allow', :role_definition_id => sales_role_def.id, :action => 'create',:resource =>'projectx_payments', :resource_type => 'record', :rank => 1 )
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

        @cust1 = FactoryGirl.create(:customer, :active => true, :name => 'cust name1', :short_name => 'short name1', :zone_id => @z1.id, :last_updated_by_id => @individual_1_u.id)
        @cust2 = FactoryGirl.create(:customer, :active => true, :name => 'cust name2', :short_name => 'short name2', :zone_id => @z2.id, :last_updated_by_id => @individual_2_u.id)
        @cust3 = FactoryGirl.create(:customer, :active => true, :name => 'cust name3', :short_name => 'short name3', :zone_id => @z3.id, :last_updated_by_id => @individual_3_u.id)
        @cust4 = FactoryGirl.create(:customer, :active => true, :name => 'cust name4', :short_name => 'short name4', :zone_id => @z4.id, :last_updated_by_id => @individual_4_u.id)
        @cust5 = FactoryGirl.create(:customer, :active => true, :name => 'cust name5', :short_name => 'short name5', :zone_id => @z5.id, :last_updated_by_id => @individual_5_u.id)

        @prj1 = FactoryGirl.create(:project, :name => 'project1', :project_desp => 'project1', :sales_id => @individual_1_u.id,:last_updated_by_id => @individual_1_u.id, :customer_id => @cust1.id )
        @prj2 = FactoryGirl.create(:project, :name => 'project2', :project_desp => 'project2', :sales_id => @individual_2_u.id,:last_updated_by_id => @individual_1_u.id, :customer_id => @cust2.id )
        @prj3 = FactoryGirl.create(:project, :name => 'project3', :project_desp => 'project3', :sales_id => @individual_3_u.id,:last_updated_by_id => @individual_3_u.id, :customer_id => @cust3.id )
        @prj4 = FactoryGirl.create(:project, :name => 'project4', :project_desp => 'project4', :sales_id => @individual_4_u.id,:last_updated_by_id => @individual_4_u.id, :customer_id => @cust4.id )
        @prj5 = FactoryGirl.create(:project, :name => 'project5', :project_desp => 'project5', :sales_id => @individual_5_u.id,:last_updated_by_id => @individual_5_u.id, :customer_id => @cust5.id )

        @contract1 = FactoryGirl.create(:contract, :project_id => @prj1.id)
        @contract2 = FactoryGirl.create(:contract, :project_id => @prj2.id)
        @contract3 = FactoryGirl.create(:contract, :project_id => @prj3.id)
        @contract4 = FactoryGirl.create(:contract, :project_id => @prj4.id)
        @contract5 = FactoryGirl.create(:contract, :project_id => @prj5.id)

        @paymnt1 = FactoryGirl.create(:payment, :contract_id => @contract1.id, :paid_amount => 101.10, :received_by_id => @individual_1_u.id, :payment_type => 'Check', :received_date => '2013/04/25')

      end

      context "Should be able to 'edit' project with proper right" do
        it "should 'edit' project with proper right" do
          session[:user_id] = @individual_1_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_1_u.id)
          get 'edit' , {:use_route => :projectx, :id => @paymnt1.id}
          response.should be_success
        end
      end

      context "should not 'edit project'" do
        before :each do
          sales_group_6 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => @type_of_user.id, :zone_id => @z5.id)
          @sales_6_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_6.id)

          sales_role_def2 = FactoryGirl.create(:role_definition, :name => 'sales2', :brief_note => "sales role")
          sales_access_right6 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'show', :role_definition_id => sales_role_def2.id, :resource =>'customerx_customers', :resource_type => 'record', :sql_code => 'Projectx::Payment.joins(:contract => :project => :customer).where(:customerx_customers => {:zone_id => session[:user_privilege].user_zone_ids})', :rank => 1 )

          @sales_user_role6 = FactoryGirl.create(:user_role, :role_definition_id => sales_role_def2.id)
          @individual_6_u = FactoryGirl.create(:user, :name => 'name6', :login => 'login6', :email => 'name6@a.com', :user_levels => [@sales_6_ul], :user_roles => [@sales_user_role6])
        end

        it "redirect with insufficient right for project 'edit' " do
          session[:user_id] = @individual_6_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_6_u.id)
          get 'edit' , {:use_route => :projectx, :id => @prj1.id}
          response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=edit and resource=projectx/payments")
        end
      end

    end

    describe "GET Update" do
      before :each do
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
        sales_access_right1 = FactoryGirl.create(:user_access, :right => 'allow', :role_definition_id => sales_role_def.id, :action => 'index', :resource =>'projectx_payments', :resource_type => 'table', :sql_code => 'Projectx::Payment.joins(:contract => :project => :customer).where(:customerx_customers => {:zone_id => session[:user_privilege].user_zone_ids})', :rank => 2 )
        sales_access_right2 = FactoryGirl.create(:user_access, :right => 'allow', :role_definition_id => sales_role_def.id, :action => 'index', :resource =>'projectx_payments', :resource_type => 'table', :sql_code => 'Projectx::Payment.joins(contract => :project => :customer).where(:customerx_customers => {:zone_id => session[:user_privilege].user_zone_ids})', :masked_attrs => 'project_num,=project_desp', :rank => 1 )
        sales_access_right3 = FactoryGirl.create(:user_access, :right => 'allow', :role_definition_id => sales_role_def.id, :action => 'update',:resource =>'projectx_payments', :resource_type => 'record', :sql_code => 'record.contract.project.sales_id  == session[:user_id]', :rank => 1 )
        sales_access_right4 = FactoryGirl.create(:user_access, :right => 'allow', :role_definition_id => sales_role_def.id, :action => 'show',  :resource =>'projectx_payments', :resource_type => 'record', :sql_code => 'record.contract.project.sales_id  == session[:user_id]', :rank => 1 )
        sales_access_right5 = FactoryGirl.create(:user_access, :right => 'allow', :role_definition_id => sales_role_def.id, :action => 'create',:resource =>'projectx_payments', :resource_type => 'record', :rank => 1 )
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

        @cust1 = FactoryGirl.create(:customer, :active => true, :name => 'cust name1', :short_name => 'short name1', :zone_id => @z1.id, :last_updated_by_id => @individual_1_u.id)
        @cust2 = FactoryGirl.create(:customer, :active => true, :name => 'cust name2', :short_name => 'short name2', :zone_id => @z2.id, :last_updated_by_id => @individual_2_u.id)
        @cust3 = FactoryGirl.create(:customer, :active => true, :name => 'cust name3', :short_name => 'short name3', :zone_id => @z3.id, :last_updated_by_id => @individual_3_u.id)
        @cust4 = FactoryGirl.create(:customer, :active => true, :name => 'cust name4', :short_name => 'short name4', :zone_id => @z4.id, :last_updated_by_id => @individual_4_u.id)
        @cust5 = FactoryGirl.create(:customer, :active => true, :name => 'cust name5', :short_name => 'short name5', :zone_id => @z5.id, :last_updated_by_id => @individual_5_u.id)

        @prj1 = FactoryGirl.create(:project, :name => 'project1', :project_desp => 'project1', :sales_id => @individual_1_u.id,:last_updated_by_id => @individual_1_u.id, :customer_id => @cust1.id )
        @prj2 = FactoryGirl.create(:project, :name => 'project2', :project_desp => 'project2', :sales_id => @individual_2_u.id,:last_updated_by_id => @individual_1_u.id, :customer_id => @cust2.id )
        @prj3 = FactoryGirl.create(:project, :name => 'project3', :project_desp => 'project3', :sales_id => @individual_3_u.id,:last_updated_by_id => @individual_3_u.id, :customer_id => @cust3.id )
        @prj4 = FactoryGirl.create(:project, :name => 'project4', :project_desp => 'project4', :sales_id => @individual_4_u.id,:last_updated_by_id => @individual_4_u.id, :customer_id => @cust4.id )
        @prj5 = FactoryGirl.create(:project, :name => 'project5', :project_desp => 'project5', :sales_id => @individual_5_u.id,:last_updated_by_id => @individual_5_u.id, :customer_id => @cust5.id )

        @contract1 = FactoryGirl.create(:contract, :project_id => @prj1.id)
        @contract2 = FactoryGirl.create(:contract, :project_id => @prj2.id)
        @contract3 = FactoryGirl.create(:contract, :project_id => @prj3.id)
        @contract4 = FactoryGirl.create(:contract, :project_id => @prj4.id)
        @contract5 = FactoryGirl.create(:contract, :project_id => @prj5.id)

        @paymnt1 = FactoryGirl.create(:payment, :contract_id => @contract1.id, :paid_amount => 101.10, :received_by_id => @individual_1_u.id, :payment_type => 'Check', :received_date => '2013/04/25')
      end

      context "Should be able to 'update' project with proper right" do
        it "should 'update' project with proper right" do
          session[:user_id] = @individual_1_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_1_u.id)
          get 'update' , {:use_route => :projectx, :id => @contract1.id}
          response.should redirect_to URI.escape("/authentify/view_handler?index=0&msg=Payment Successfully Updated!")
        end
      end

      context "should not 'update' project" do
        before :each do
          sales_group_6 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => @type_of_user.id, :zone_id => @z5.id)
          @sales_6_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_6.id)

          sales_role_def2 = FactoryGirl.create(:role_definition, :name => 'sales2', :brief_note => "sales role")
          sales_access_right6 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'show', :role_definition_id => sales_role_def2.id, :resource =>'customerx_customers', :resource_type => 'record', :sql_code => 'Projectx::Payment.joins(:contract => :project => :customer).where(:customerx_customers => {:zone_id => session[:user_privilege].user_zone_ids})', :rank => 1 )

          @sales_user_role6 = FactoryGirl.create(:user_role, :role_definition_id => sales_role_def2.id)
          @individual_6_u = FactoryGirl.create(:user, :name => 'name6', :login => 'login6', :email => 'name6@a.com', :user_levels => [@sales_6_ul], :user_roles => [@sales_user_role6])
        end

        it "redirect with insufficient right for project 'update' " do
          session[:user_id] = @individual_6_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_6_u.id)
          get 'update' , {:use_route => :projectx, :id => @contract1.id}
          response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=update and resource=projectx/payments")
        end
      end

    end

    describe "GET show" do
      before :each do
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
        sales_access_right1 = FactoryGirl.create(:user_access, :right => 'allow', :role_definition_id => sales_role_def.id, :action => 'index', :resource =>'projectx_payments', :resource_type => 'table', :sql_code => 'Projectx::Payment.joins(:contract => :project => :customer).where(:customerx_customers => {:zone_id => session[:user_privilege].user_zone_ids})', :rank => 2 )
        sales_access_right2 = FactoryGirl.create(:user_access, :right => 'allow', :role_definition_id => sales_role_def.id, :action => 'index', :resource =>'projectx_payments', :resource_type => 'table', :sql_code => 'Projectx::Payment.joins(:contract => :project => :customer).where(:customerx_customers => {:zone_id => session[:user_privilege].user_zone_ids})', :masked_attrs => 'project_num,=project_desp', :rank => 1 )
        sales_access_right3 = FactoryGirl.create(:user_access, :right => 'allow', :role_definition_id => sales_role_def.id, :action => 'update',:resource =>'projectx_payments', :resource_type => 'record', :sql_code => 'record.contract.project.sales_id  == session[:user_id]', :rank => 1 )
        sales_access_right4 = FactoryGirl.create(:user_access, :right => 'allow', :role_definition_id => sales_role_def.id, :action => 'show',  :resource =>'projectx_payments', :resource_type => 'record', :sql_code => 'record.contract.project.sales_id  == session[:user_id]', :rank => 1 )
        sales_access_right5 = FactoryGirl.create(:user_access, :right => 'allow', :role_definition_id => sales_role_def.id, :action => 'create',:resource =>'projectx_payments', :resource_type => 'record', :rank => 1 )
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

        @cust1 = FactoryGirl.create(:customer, :active => true, :name => 'cust name1', :short_name => 'short name1', :zone_id => @z1.id, :last_updated_by_id => @individual_1_u.id)
        @cust2 = FactoryGirl.create(:customer, :active => true, :name => 'cust name2', :short_name => 'short name2', :zone_id => @z2.id, :last_updated_by_id => @individual_2_u.id)
        @cust3 = FactoryGirl.create(:customer, :active => true, :name => 'cust name3', :short_name => 'short name3', :zone_id => @z3.id, :last_updated_by_id => @individual_3_u.id)
        @cust4 = FactoryGirl.create(:customer, :active => true, :name => 'cust name4', :short_name => 'short name4', :zone_id => @z4.id, :last_updated_by_id => @individual_4_u.id)
        @cust5 = FactoryGirl.create(:customer, :active => true, :name => 'cust name5', :short_name => 'short name5', :zone_id => @z5.id, :last_updated_by_id => @individual_5_u.id)

        @status_prj = FactoryGirl.create(:misc_definition, :name => 'started', :active => true, :for_which => 'project')
        @prj1 = FactoryGirl.create(:project, :name => 'project1', :project_desp => 'project1', :sales_id => @individual_1_u.id,:last_updated_by_id => @individual_1_u.id, :customer_id => @cust1.id, :status_id => @status_prj.id )
        @prj2 = FactoryGirl.create(:project, :name => 'project2', :project_desp => 'project2', :sales_id => @individual_2_u.id,:last_updated_by_id => @individual_1_u.id, :customer_id => @cust2.id, :status_id => @status_prj.id )
        @prj3 = FactoryGirl.create(:project, :name => 'project3', :project_desp => 'project3', :sales_id => @individual_3_u.id,:last_updated_by_id => @individual_3_u.id, :customer_id => @cust3.id, :status_id => @status_prj.id )
        @prj4 = FactoryGirl.create(:project, :name => 'project4', :project_desp => 'project4', :sales_id => @individual_4_u.id,:last_updated_by_id => @individual_4_u.id, :customer_id => @cust4.id, :status_id => @status_prj.id )
        @prj5 = FactoryGirl.create(:project, :name => 'project5', :project_desp => 'project5', :sales_id => @individual_5_u.id,:last_updated_by_id => @individual_5_u.id, :customer_id => @cust5.id, :status_id => @status_prj.id )

        @contract1 = FactoryGirl.create(:contract, :project_id => @prj1.id)
        @contract2 = FactoryGirl.create(:contract, :project_id => @prj2.id)
        @contract3 = FactoryGirl.create(:contract, :project_id => @prj3.id)
        @contract4 = FactoryGirl.create(:contract, :project_id => @prj4.id)
        @contract5 = FactoryGirl.create(:contract, :project_id => @prj5.id)

        @paymnt1 = FactoryGirl.create(:payment, :contract_id => @contract1.id, :paid_amount => 101.10, :received_by_id => @individual_1_u.id, :payment_type => 'Check', :received_date => '2013/04/25', :last_updated_by_id => @individual_1_u.id)

      end

      context "should show projects for user with proper right" do
        it "shows projects" do
          session[:user_id] = @individual_1_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_1_u.id)
          get 'show' , {:use_route => :projectx, :id => @paymnt1.id}
          response.should be_success
        end
      end

      context "should not 'show project'" do
        before :each do
          sales_group_6 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => @type_of_user.id, :zone_id => @z5.id)
          @sales_6_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_6.id)

          sales_role_def2 = FactoryGirl.create(:role_definition, :name => 'sales2', :brief_note => "sales role")
          sales_access_right6 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'show', :role_definition_id => sales_role_def2.id, :resource =>'customerx_customers', :resource_type => 'record', :sql_code => 'Projectx::Payment.joins(:contract => :project => :customer).where(:customerx_customers => {:zone_id => session[:user_privilege].user_zone_ids})', :rank => 1 )

          @sales_user_role6 = FactoryGirl.create(:user_role, :role_definition_id => sales_role_def2.id)
          @individual_6_u = FactoryGirl.create(:user, :name => 'name6', :login => 'login6', :email => 'name6@a.com', :user_levels => [@sales_6_ul], :user_roles => [@sales_user_role6])
        end

        it "redirect with insufficient right for user with no sufficient rights" do
          session[:user_id] = @individual_6_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_6_u.id)
          get 'show' , {:use_route => :projectx, :id => @contract1.id}
          response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=show and resource=projectx/payments")
        end
      end

    end

    describe "GET search" do
      context "Has no access right for 'search' project " do
        before :each do
          sales_group_6 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => @type_of_user.id, :zone_id => @z5.id)
          @sales_6_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_6.id)

          sales_role_def2 = FactoryGirl.create(:role_definition, :name => 'sales2', :brief_note => "sales role")
          sales_access_right6 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'show', :role_definition_id => sales_role_def2.id, :resource =>'customerx_customers', :resource_type => 'record', :sql_code => 'Projectx::Payment.joins(:contract => :project => :customer).where(:customerx_customers => {:zone_id => session[:user_privilege].user_zone_ids})', :rank => 1 )

          @sales_user_role6 = FactoryGirl.create(:user_role, :role_definition_id => sales_role_def2.id)
          @individual_6_u = FactoryGirl.create(:user, :name => 'name6', :login => 'login6', :email => 'name6@a.com', :user_levels => [@sales_6_ul], :user_roles => [@sales_user_role6])
        end

        it "redirect with insufficient right " do
          session[:user_id] = @individual_6_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_6_u)
          get 'search' , {:use_route => :projectx}
          assigns(:payments).should be_blank
          response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=search and resource=projectx/payments")
        end
      end

      context "Has access right for 'search' project" do
        before :each do
          sales_role_def = FactoryGirl.create(:role_definition, :name => 'sales', :brief_note => "sales role")
          sales_access_right1 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'search', :role_definition_id => sales_role_def.id, :resource =>'projectx_payments', :resource_type => 'record', :rank => 1 )

          sales_group_3 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => @type_of_user.id, :zone_id => @z3.id)
          @sales_3_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_3.id)
          @sales_user_role3 = FactoryGirl.create(:user_role, :role_definition_id => sales_role_def.id)
          @individual_7_u = FactoryGirl.create(:user, :name => 'name7', :login => 'login7', :email => 'name7@a.com', :user_levels => [@sales_3_ul], :user_roles => [@sales_user_role3])

          cust3 = FactoryGirl.create(:customer, :active => true, :name => 'cust name3', :short_name => 'short name3', :zone_id => @z3.id, :last_updated_by_id => @individual_7_u.id)
          cust4 = FactoryGirl.create(:customer, :active => true, :name => 'cust name4', :short_name => 'short name4', :zone_id => @z3.id, :last_updated_by_id => @individual_7_u.id)
          cust5 = FactoryGirl.create(:customer, :active => true, :name => 'cust name5', :short_name => 'short name5', :zone_id => @z3.id, :last_updated_by_id => @individual_7_u.id)
        end

        it "should allow for search project with proper right" do
          session[:user_id] = @individual_7_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_7_u.id)
          get 'search' , {:use_route => :projectx, :zone_id_s => 'zone3', :sales_id_s => 'name3', :customer_id_s => 'cust name3'}
          response.should be_success
        end
      end
    end


    describe "GET 'search_results'" do
      before :each do
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
        sales_access_right1 = FactoryGirl.create(:user_access, :right => 'allow', :role_definition_id => sales_role_def.id, :action => 'search', :resource =>'projectx_payments', :resource_type => 'table', :sql_code => 'Projectx::Payment.joins(:contract => {:project => :customer}).where(:customerx_customers => {:zone_id => session[:user_privilege].user_zone_ids})', :rank => 2 )
        sales_access_right2 = FactoryGirl.create(:user_access, :right => 'allow', :role_definition_id => sales_role_def.id, :action => 'search', :resource =>'projectx_payments', :resource_type => 'table', :sql_code => 'Projectx::Payment.joins(:contract => {:project => :customer}).where(:customerx_customers => {:zone_id => session[:user_privilege].user_zone_ids})', :masked_attrs => 'project_num,=project_desp', :rank => 1 )
        sales_access_right3 = FactoryGirl.create(:user_access, :right => 'allow', :role_definition_id => sales_role_def.id, :action => 'update',:resource =>'projectx_payments', :resource_type => 'record', :sql_code => 'record.contract.project.sales_id  == session[:user_id]', :rank => 1 )
        sales_access_right4 = FactoryGirl.create(:user_access, :right => 'allow', :role_definition_id => sales_role_def.id, :action => 'show',  :resource =>'projectx_payments', :resource_type => 'record', :sql_code => 'record.contract.project.sales_id  == session[:user_id]', :rank => 1 )
        sales_access_right5 = FactoryGirl.create(:user_access, :right => 'allow', :role_definition_id => sales_role_def.id, :action => 'create',:resource =>'projectx_payments', :resource_type => 'record', :rank => 1 )
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

        @cust1 = FactoryGirl.create(:customer, :active => true, :name => 'cust name1', :short_name => 'short name1', :zone_id => @z1.id, :last_updated_by_id => @individual_1_u.id)
        @cust2 = FactoryGirl.create(:customer, :active => true, :name => 'cust name2', :short_name => 'short name2', :zone_id => @z2.id, :last_updated_by_id => @individual_2_u.id)
        @cust3 = FactoryGirl.create(:customer, :active => true, :name => 'cust name3', :short_name => 'short name3', :zone_id => @z3.id, :last_updated_by_id => @individual_3_u.id)
        @cust4 = FactoryGirl.create(:customer, :active => true, :name => 'cust name4', :short_name => 'short name4', :zone_id => @z4.id, :last_updated_by_id => @individual_4_u.id)
        @cust5 = FactoryGirl.create(:customer, :active => true, :name => 'cust name5', :short_name => 'short name5', :zone_id => @z5.id, :last_updated_by_id => @individual_5_u.id)

        @prj1 = FactoryGirl.create(:project, :name => 'project1', :project_desp => 'project1', :sales_id => @individual_1_u.id,:last_updated_by_id => @individual_1_u.id, :customer_id => @cust1.id )
        @prj2 = FactoryGirl.create(:project, :name => 'project2', :project_desp => 'project2', :sales_id => @individual_2_u.id,:last_updated_by_id => @individual_1_u.id, :customer_id => @cust2.id )
        @prj3 = FactoryGirl.create(:project, :name => 'project3', :project_desp => 'project3', :sales_id => @individual_3_u.id,:last_updated_by_id => @individual_3_u.id, :customer_id => @cust3.id )
        @prj4 = FactoryGirl.create(:project, :name => 'project4', :project_desp => 'project4', :sales_id => @individual_4_u.id,:last_updated_by_id => @individual_4_u.id, :customer_id => @cust1.id )
        @prj5 = FactoryGirl.create(:project, :name => 'project5', :project_desp => 'project5', :sales_id => @individual_5_u.id,:last_updated_by_id => @individual_5_u.id, :customer_id => @cust2.id )

        @contract1 = FactoryGirl.create(:contract, :project_id => @prj1.id)
        @contract2 = FactoryGirl.create(:contract, :project_id => @prj2.id)
        @contract3 = FactoryGirl.create(:contract, :project_id => @prj3.id)
        @contract4 = FactoryGirl.create(:contract, :project_id => @prj4.id)
        @contract5 = FactoryGirl.create(:contract, :project_id => @prj5.id)

        @paymnt1 = FactoryGirl.create(:payment, :contract_id => @contract1.id, :paid_amount => 101.10, :received_by_id => @individual_1_u.id, :payment_type => 'Check', :received_date => '2013/04/25')
        @paymnt2 = FactoryGirl.create(:payment, :contract_id => @contract2.id, :paid_amount => 201.10, :received_by_id => @individual_2_u.id, :payment_type => 'Cash', :received_date => '2013/04/25')
        @paymnt3 = FactoryGirl.create(:payment, :contract_id => @contract3.id, :paid_amount => 301.10, :received_by_id => @individual_3_u.id, :payment_type => 'Credit Card', :received_date => '2013/04/25')
        @paymnt4 = FactoryGirl.create(:payment, :contract_id => @contract4.id, :paid_amount => 401.10, :received_by_id => @individual_4_u.id, :payment_type => 'Check', :received_date => '2013/04/25')
        @paymnt5 = FactoryGirl.create(:payment, :contract_id => @contract5.id, :paid_amount => 501.10, :received_by_id => @individual_2_u.id, :payment_type => 'Check', :received_date => '2013/04/25')
      end

      context "Has individual 'search_results' access right " do

        it "returns projects list for this individual user" do
          session[:user_id] = @individual_3_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_3_u)
          get 'search_results' , {:use_route => :projectx, :zone_id_s => @z3.id.to_s, :sales_id_s => @individual_3_u.id.to_s, :customer_id_s => @cust3.id.to_s}
          assigns(:payments).should =~ [@paymnt3]
        end

        it "returns projects search results list for this individual user" do
          session[:user_id] = @individual_2_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_2_u)
          get 'search_results' , {:use_route => :projectx, :zone_id_s => @z2.id.to_s, :sales_id_s => @individual_2_u.id.to_s, :customer_id_s => @cust2.id.to_s}
          assigns(:payments).should =~ [@paymnt2, @paymnt5]
        end
      end

      context "Has global 'search_results' access right " do
        before :each do
          ceo_group     = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => @type_of_user.id, :zone_id => @z1.id)
          ceo_role_def = FactoryGirl.create(:role_definition, :name => "ceo", :brief_note => "ceo role")

          ceo_access_right1 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'search', :role_definition_id => ceo_role_def.id, :resource => 'projectx_payments', :resource_type => 'table' )
          ceo_access_right2 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'update', :role_definition_id => ceo_role_def.id, :resource => 'projectx_payments', :resource_type => 'table' )
          ceo_access_right3 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'show', :role_definition_id => ceo_role_def.id, :resource => 'projectx_payments', :resource_type => 'table' )
          ceo_access_right4 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'show', :role_definition_id => ceo_role_def.id, :resource =>'customerx_customers', :resource_type => 'table' )
          ceo_access_right5 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'create', :role_definition_id => ceo_role_def.id, :resource =>'projectx_payments', :resource_type => 'table' )

          @ceo_ul       = FactoryGirl.build(:user_level, :sys_user_group_id => ceo_group.id)
          @ceo_user_role = FactoryGirl.create(:user_role, :role_definition_id => ceo_role_def.id)
          @ceo_u = FactoryGirl.create(:user, :name => 'ceo', :login => 'ceo111', :email => 'ceo@a.com', :user_levels => [@ceo_ul], :user_roles => [@ceo_user_role])

        end

        it "returns payments list " do
          session[:user_id] = @ceo_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@ceo_u)
          get 'search_results' , {:use_route => :projectx, :zone_id_s => @z1.id.to_s, :sales_id_s => @ceo_u.id.to_s, :customer_id_s => @cust3.id.to_s}
          assigns(:payments).should =~ [@paymnt1, @paymnt2, @paymnt3, @paymnt4, @paymnt5]
        end
      end

      context "Has only records 'search_results' access right " do
        before :each do
          manager_group = FactoryGirl.create(:sys_user_group, :user_group_name => 'regional_manager', :group_type_id => @type_of_user.id, :zone_id => @z2.id)
          manager_role_def = FactoryGirl.create(:role_definition, :name => 'manager', :brief_note => "manager role")
          manager_access_right1 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'search', :role_definition_id => manager_role_def.id, :resource =>'projectx_payments', :resource_type => 'table', :sql_code => 'Projectx::Payment.joins(:contract => {:project => :customer}).where(:customerx_customers => {:zone_id => session[:user_privilege].user_zone_ids})', :masked_attrs => 'project_num,=project_desp', :rank => 1 )
          manager_access_right3 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'update', :role_definition_id => manager_role_def.id, :resource =>'projectx_payments', :resource_type => 'record', :sql_code => 'record.contract.project.sales_id  == session[:user_id]', :rank => 1 )
          manager_access_right4 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'show', :role_definition_id => manager_role_def.id, :resource =>'projectx_payments', :resource_type => 'record', :sql_code => 'record.contract.project.sales_id  == session[:user_id]', :rank => 1 )
          manager_access_right5 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'create', :role_definition_id => manager_role_def.id, :resource =>'projectx_payments', :resource_type => 'record', :rank => 1 )
          manager_access_right6 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'show', :role_definition_id => manager_role_def.id, :resource =>'customerx_customers', :resource_type => 'record', :sql_code => 'record.sales_id  == session[:user_id]' )

          @manager_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => manager_group.id)
          @manager_user_role = FactoryGirl.create(:user_role, :role_definition_id => manager_role_def.id)
          @manager_u = FactoryGirl.create(:user, :name => 'manager', :login => 'manager', :email => 'manager@a.com', :user_levels => [@manager_ul], :user_roles => [@manager_user_role])
        end

        it "returns projects list " do
          session[:user_id] = @manager_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@manager_u)
          get 'search_results' , {:use_route => :projectx, :zone_id_s => @z2.id.to_s, :sales_id_s => @manager_u.id.to_s, :customer_id_s => @cust2.id.to_s}
          assigns(:payments).should =~ [@paymnt2, @paymnt5]
        end
      end

      context "Has no 'search_results' access right " do
        before :each do
          sales_group_6 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :group_type_id => @type_of_user.id, :zone_id => @z5.id)
          @sales_6_ul   = FactoryGirl.build(:user_level, :sys_user_group_id => sales_group_6.id)

          sales_role_def2 = FactoryGirl.create(:role_definition, :name => 'sales2', :brief_note => "sales role")
          sales_access_right6 = FactoryGirl.create(:user_access, :right => 'allow', :action => 'search', :role_definition_id => sales_role_def2.id, :resource =>'customerx_customers', :resource_type => 'record', :sql_code => 'Projectx::Project.where(:zone_id =>  session[:user_privilege].user_zone_ids)', :rank => 1 )

          @sales_user_role6 = FactoryGirl.create(:user_role, :role_definition_id => sales_role_def2.id)
          @individual_6_u = FactoryGirl.create(:user, :name => 'name6', :login => 'login6', :email => 'name6@a.com', :user_levels => [@sales_6_ul], :user_roles => [@sales_user_role6])
        end

        it "returns an empty list " do
          session[:user_id] = @individual_6_u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@individual_6_u)
          get 'search_results' , {:use_route => :projectx}
          assigns(:payments).should be_blank
          response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=search_results and resource=projectx/payments")
        end
      end

    end


  end
end
