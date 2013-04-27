# encoding: utf-8
module Projectx
  class Project < ActiveRecord::Base
    include Authentify::AuthentifyUtility

      after_initialize :default_init, :if => :new_record?

      attr_accessible :name, :project_num, :customer_id, :project_task_template_id, :project_desp, :start_date,
                      :end_date, :delivery_date, :estimated_delivery_date, :project_instruction, :project_manager_id,
                      :cancelled, :completed, :last_updated_by_id, :expedite, :contracts_attributes,
                      :customer_name_autocomplete, :sales_id, :status_id, :completion_percent, :project_date,
                      :as => :role_new
                      
      attr_accessible :name, :project_num, :customer_id, :project_task_template_id, :project_desp, :start_date,
                      :end_date, :delivery_date, :estimated_delivery_date, :project_instruction, :project_manager_id,
                      :cancelled, :completed, :last_updated_by_id, :expedite, :contracts_attributes,
                      :customer_name_autocomplete, :sales_id, :status_id, :completion_percent, :project_date,
                      :as => :role_update


      attr_accessor :project_id_s, :keyword, :start_date_s, :end_date_s, :customer_id_s, :status_s, :expedite_s,
                    :completion_percent_s, :zone_id_s, :sales_id_s, :payment_percent_s, :completion_percent,
                    :project_task_template_id_s, :project_date_s

      attr_accessible :project_id_s, :keyword, :start_date_s, :end_date_s, :customer_id_s, :status_s, :expedite_s,
                    :completion_percent_s, :zone_id_s, :sales_id_s, :payment_percent_s, :project_task_template_id_s,
                    :project_date_s,
                    :as => :role_search_stats

                    
      belongs_to :status, :class_name => 'Projectx::MiscDefinition'
      belongs_to :customer, :class_name => 'Customerx::Customer'
      #belongs_to :zone, :class_name => 'Authentify::Zone'
      belongs_to :sales, :class_name => 'Authentify::User'
      belongs_to :last_updated_by, :class_name => 'Authentify::User'
      belongs_to :project_manager, :class_name => 'Authentify::User'
      belongs_to :project_task_template, :class_name => 'Projectx::ProjectTaskTemplate'
      has_many :logs, :class_name => 'Projectx::Log'
      has_many :tasks, :class_name => 'Projectx::Task'
      has_one :contract, :class_name => 'Projectx::Contract'
      accepts_nested_attributes_for :contract, :allow_destroy => true
    
      validates :name, :presence => true,
                       :uniqueness => {:case_sensitive => false, :message => 'Duplicate project name'}
      validates :project_num, :presence => true, 
                              :uniqueness => {:case_sensitive => false, :message => 'Duplicated project num'}
      validates_presence_of :project_manager_id, :project_task_template_id, :start_date,
                            :end_date, :delivery_date
      validates :customer_id, :presence => true,
                              :numericality => {:greater_than => 0}
      validates :sales_id, :presence => true,
                           :numericality => {:greater_than => 0}


      def sales_id
        engine_config_prj_sales = find_config_const('project_has_sales', 'projectx')
        if engine_config_prj_sales.nil? or engine_config_prj_sales == 'false'
          customer.sales.id
        else
          read_attribute(:sales_id)
        end
      end

      def sales_id=(new_sales_id)
        engine_config_prj_sales = find_config_const('project_has_sales', 'projectx')
        if engine_config_prj_sales.nil? or engine_config_prj_sales == 'false'
          customer.sales_id = new_sales_id
        else
          write_attribute(:sales_id, new_sales_id)
        end
      end

      def default_init
        project_num_time_gen = find_config_const('project_num_time_gen', 'projectx')
        self.project_num = eval(project_num_time_gen)
      end

    def customer_name_autocomplete
        self.customer.try(:name)
      end

      def customer_name_autocomplete=(name)
        self.customer = Customerx::Customer.find_by_name(name) if name.present?
      end

  end
end
