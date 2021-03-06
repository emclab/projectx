# encoding: utf-8

module Projectx
  class Project < ActiveRecord::Base
    include Authentify::AuthentifyUtility

      after_initialize :default_init, :if => :new_record?
      
      attr_accessor :sales_name, :last_updated_by_name, :project_manager_name, :status_name

      attr_accessible :name, :project_num, :customer_id, :project_task_template_id, :project_desp, :start_date,
                      :end_date, :delivery_date, :estimated_delivery_date, :project_instruction, :project_manager_id,
                      :cancelled, :completed, :last_updated_by_id, :expedite, 
                      :customer_name_autocomplete, :sales_id, :status_id, :completion_percent, :contract_attributes,
                      :sales_name, :last_updated_by_name, :project_manager_name, :status_name, 
                      :as => :role_new
                      
      attr_accessible :name, :project_num, :customer_id, :project_task_template_id, :project_desp, :start_date,
                      :end_date, :delivery_date, :estimated_delivery_date, :project_instruction, :project_manager_id,
                      :cancelled, :completed, :last_updated_by_id, :expedite,
                      :customer_name_autocomplete, :sales_id, :status_id, :completion_percent, :contract_attributes,
                      :sales_name, :last_updated_by_name, :project_manager_name, :status_name, 
                      :as => :role_update


      attr_accessor :project_id_s, :keyword_s, :start_date_s, :end_date_s, :customer_id_s, :status_s, :expedite_s,
                    :completion_percent_s, :zone_id_s, :sales_id_s, :project_task_template_id_s, 
                    :time_frame_s

      attr_accessible :project_id_s, :keyword_s, :start_date_s, :end_date_s, :customer_id_s, :status_s, :expedite_s,
                    :zone_id_s, :sales_id_s, :project_task_template_id_s, :time_frame_s,
                    :as => :role_search_stats

                    
      belongs_to :status, :class_name => 'Commonx::MiscDefinition'
      belongs_to :customer, :class_name => 'Customerx::Customer'
      #belongs_to :zone, :class_name => 'Authentify::Zone'
      belongs_to :sales, :class_name => 'Authentify::User'
      belongs_to :last_updated_by, :class_name => 'Authentify::User'
      belongs_to :project_manager, :class_name => 'Authentify::User'
      belongs_to :project_task_template, :class_name => 'Projectx::ProjectTaskTemplate'
      #has_many :logs, :class_name => 'Projectx::Log'
      has_many :tasks, :class_name => 'Projectx::Task'
      has_one :contract, :class_name => 'Projectx::Contract'
      accepts_nested_attributes_for :contract  #, :allow_destroy => true
    
      validates :name, :presence => true,
                       :uniqueness => {:case_sensitive => false, :message => I18n.t('Duplicate Name!')}
      validates :project_num, :presence => true, 
                              :uniqueness => {:case_sensitive => false, :message => I18n.t('Duplicate Project Number')}
      validates_presence_of :project_task_template_id, :start_date  #, :project_date
      validates :customer_id, :presence => true,
                              :numericality => {:greater_than => 0}
      validates :sales_id, :presence => true,
                           :numericality => {:greater_than => 0} if :validate_sales

      def validate_sales
        return find_config_const('project_has_sales', 'projectx') == 'true'
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
