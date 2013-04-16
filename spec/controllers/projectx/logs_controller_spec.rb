require 'spec_helper'

module Projectx
  describe LogsController do
    before(:each) do
      controller.should_receive(:require_signin)
    end
  
    render_views
    
    describe "GET 'index'" do
      it "returns project logs for users with index right with @project passes in" do
        cate = Customerx::MiscDefinition.create({:for_which => 'customer_status', :name => 'order category'}, :as => :role_new) #FactoryGirl.create(:misc_definition, :for_which => 'customer_status', :name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access = FactoryGirl.create(:user_access, :action => 'index_project', :resource => 'projectx_logs', :role_definition_id => role.id, :rank => 1,
        :sql_code => "Projectx::Log.where('project_id > ? AND created_at > ?', 0, 2.years.ago).order('id DESC')")
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :sales_id => u.id + 1, 
                                  :zone_id => z.id, :customer_status_category_id => cate.id)
        lead = FactoryGirl.create(:project, :customer_id => cust.id)
        log = FactoryGirl.create(:log, :project_id => lead.id, :task_id => nil, :task_request_id => nil)
        get 'index', {:use_route => :projectx, :project_id => lead.id, :which_table => 'project', :subaction => 'project'}
        #response.should be_success
        assigns(:logs).should eq([log])
      end
      
      it "returns project logs for users with index group right without @project passes in" do
        cate = Customerx::MiscDefinition.create({:for_which => 'customer_status', :name => 'order category'}, :as => :role_new) #FactoryGirl.create(:misc_definition, :for_which => 'customer_status', :name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access = FactoryGirl.create(:user_access, :action => 'index_project', :resource => 'projectx_logs', :role_definition_id => role.id, :rank => 1,
        :sql_code => "Projectx::Log.joins(:project => :customer).
        where(:customerx_customers => {:sales_id => Authentify::UserLevel.where(:sys_user_group_id => session[:user_privilege].user_group_ids + session[:user_privilege].sub_group_ids).select('user_id')}).
        where('projectx_logs.project_id > ? AND projectx_logs.created_at > ?', 0, 2.years.ago).order('id DESC')")
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        ur1 = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul1 = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id+1)
        u1 = FactoryGirl.create(:user, :user_levels => [ul1], :user_roles => [ur1], :name => 'a guy', :login => 'nenn876', :email => 'new@a.com')
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :sales_id => u.id , 
                                  :zone_id => z.id, :customer_status_category_id => cate.id)
        cust1 = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u1.id, :sales_id => u1.id, 
                                  :zone_id => z.id, :customer_status_category_id => cate.id, :name => 'newnew', :short_name => 'manman')
        lead = FactoryGirl.create(:project, :customer_id => cust.id)
        lead1 = FactoryGirl.create(:project, :customer_id => cust1.id, :name => 'newnew', :project_num =>'nodup')
        log = FactoryGirl.create(:log, :project_id => lead.id, :task_id => nil, :task_request_id => nil)
        log1 = FactoryGirl.create(:log, :project_id => lead1.id, :task_id => nil, :task_request_id => nil)
        get 'index', {:use_route => :projectx, :project_id => nil, :which_table => 'project', :subaction => 'project'}
        #response.should be_success
        assigns(:logs).should eq([log])
      end
      
      it "should return all logs for sales_lead for user with index right without @task_request passes in" do
        cate = Customerx::MiscDefinition.create({:for_which => 'customer_status', :name => 'order category'}, :as => :role_new) 
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access = FactoryGirl.create(:user_access, :action => 'index_task_request', :resource => 'projectx_logs', :role_definition_id => role.id, :rank => 1,
        :sql_code => "Projectx::Log.joins(:task_request => {:task => {:project => :customer}}).
        where(:customerx_customers => {:sales_id => session[:user_id]}).
        where('projectx_logs.task_request_id > ? AND projectx_logs.created_at > ?', 0, 2.years.ago)")
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :sales_id => u.id + 1, :customer_status_category_id => cate.id)
        proj = FactoryGirl.create(:project, :customer_id => cust.id)
        task = FactoryGirl.create(:task, :project_id => proj.id)
        lead = FactoryGirl.create(:task_request, :task_id => task.id)
        log = FactoryGirl.create(:log, :task_request_id => lead.id, :project_id => nil, :task_id => nil)
        log1 = FactoryGirl.create(:log, :log => 'newnew', :task_request_id => lead.id, :project_id => nil, :task_id => nil)
        get 'index', {:use_route => :projectx, :task_reqeust_id => lead.id, :which_table => 'task_request', :subaction => 'task_request'}
        #response.should be_success
        assigns(:logs).should eq([])
      end
      
      it "should return all logs for sales_lead for user with index right matching group_id without @sales_lead passes in" do
        cate = FactoryGirl.create(:misc_definition, :for_which => 'customer_status', :name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access = FactoryGirl.create(:user_access, :action => 'index_sales_lead', :resource => 'projectx_logs', :role_definition_id => role.id, :rank => 1,
        :sql_code => "Customerx::Log.joins(:sales_lead => :customer).
        where(:projectx_customers => {:sales_id => Authentify::UserLevel.where(:sys_user_group_id => session[:user_privilege].user_group_ids + session[:user_privilege].sub_group_ids).select('user_id')}).
        where('customerx_logs.sales_lead_id > ? AND customerx_logs.created_at > ?', 0, 2.years.ago)")
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :sales_id => u.id, :customer_status_category_id => cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)
        log = FactoryGirl.create(:log, :sales_lead_id => lead.id, :customer_comm_record_id => nil)
        log1 = FactoryGirl.create(:log, :log => 'newnew', :sales_lead_id => lead.id, :customer_comm_record_id => nil)
        get 'index', {:use_route => :projectx, :sales_lead_id => nil, :which_table => 'sales_lead', :subaction => 'sales_lead'}
        #response.should be_success
        assigns(:logs).should eq([log, log1])
      end
       
      it "returns customer comm record logs for users with index right with @customer_comm_record passes in" do
        cate = FactoryGirl.create(:misc_definition, :for_which => 'customer_status', :name => 'order category')
        c_cate = FactoryGirl.create(:misc_definition, :for_which => 'customer_comm_record')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access = FactoryGirl.create(:user_access, :action => 'index_customer_comm_record', :resource => 'projectx_logs', :role_definition_id => role.id, :rank => 1,
        :sql_code => "Customerx::Log.where('customer_comm_record_id > ? AND created_at > ?', 0, 2.years.ago)")
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :sales_id => u.id + 1,:customer_status_category_id => cate.id)
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id, :comm_category_id => c_cate.id)
        log = FactoryGirl.create(:log, :customer_comm_record_id => rec.id, :sales_lead_id => nil)
        get 'index', {:use_route => :projectx, :customer_comm_record_id => rec.id, :which_table => 'customer_comm_record', :subaction => 'customer_comm_record'}
        #response.should be_success
        assigns(:logs).should eq([log])
      end
      
      it "should return logs for customer comm record for users with index right without @customer_comm_record passes in" do
        cate = FactoryGirl.create(:misc_definition, :for_which => 'customer_status', :name => 'order category')
        c_cate = FactoryGirl.create(:misc_definition, :for_which => 'customer_comm_record')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access = FactoryGirl.create(:user_access, :action => 'index_customer_comm_record', :resource => 'projectx_logs', :role_definition_id => role.id, :rank => 1,
        :sql_code => "Customerx::Log.where('customer_comm_record_id > ? AND created_at > ?', 0, 2.years.ago)")
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :sales_id => u.id + 1, :customer_status_category_id => cate.id)
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id, :comm_category_id => c_cate.id)
        log = FactoryGirl.create(:log, :customer_comm_record_id => rec.id, :sales_lead_id => nil)
        log1 = FactoryGirl.create(:log, :log => 'newnew', :customer_comm_record_id => rec.id, :sales_lead_id => nil)
        get 'index', {:use_route => :projectx, :customer_comm_record_id => nil, :which_table => 'customer_comm_record', :subaction => 'customer_comm_record'}
        #response.should be_success
        assigns(:logs).should eq([log,log1])
      end
      
      it "should reject no right" do
        cate = FactoryGirl.create(:misc_definition, :for_which => 'customer_status', :name => 'order category')
        c_cate = FactoryGirl.create(:misc_definition, :for_which => 'customer_comm_record')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access = FactoryGirl.create(:user_access, :action => 'no_index_customer_comm_record', :resource => 'projectx_logs', :role_definition_id => role.id, :rank => 1,
        :sql_code => "Customerx::Log.where('customer_comm_record_id > ? AND created_at > ?', 0, 2.years.ago)")
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :sales_id => u.id, :customer_status_category_id => cate.id)
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id, :comm_category_id => c_cate.id)
        log = FactoryGirl.create(:log, :customer_comm_record_id => rec.id, :sales_lead_id => nil)
        log1 = FactoryGirl.create(:log, :log => 'newnew', :customer_comm_record_id => rec.id, :sales_lead_id => nil)
        get 'index', {:use_route => :projectx, :customer_comm_record_id => rec.id, :which_table => 'customer_comm_record', :subaction =>'customer_comm_record'}
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!")
      end
    end
  
    describe "GET 'new'" do
      it "returns http success" do
        get 'new'
        response.should be_success
      end
    end
  
    describe "GET 'create'" do
      it "returns http success" do
        get 'create'
        response.should be_success
      end
    end
  
    describe "GET 'edit'" do
      it "returns http success" do
        get 'edit'
        response.should be_success
      end
    end
  
    describe "GET 'update'" do
      it "returns http success" do
        get 'update'
        response.should be_success
      end
    end
  
  end
end
