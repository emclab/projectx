module Projectx
  class Project < ActiveRecord::Base
      attr_accessible :name, :project_num, :customer_id, :project_type_id, :zone_id, :project_desp, :sales_id, :start_date,
                      :end_date, :delivery_date, :estimated_delivery_date, :project_instruction, :project_manager_id,
                      :cancelled, :completed, :last_updated_by_id, :expedite, :contracts_attributes,
                      :as => :role_new
                      
      attr_accessible :name, :project_num, :customer_id, :project_type_id, :zone_id, :project_desp, :sales_id, :start_date,
                      :end_date, :delivery_date, :estimated_delivery_date, :project_instruction, :project_manager_id,
                      :cancelled, :completed, :last_updated_by_id, :expedite, :contracts_attributes, 
                      :as => :role_update


      attr_accessor :project_id_s, :keyword, :start_date_s, :end_date_s, :customer_id_s, :status_s, :expedite_s,
                    :completion_percent_s, :zone_id_s, :sales_id_s, :payment_percent_s, :completion_percent

      attr_accessible :project_id_s, :keyword, :start_date_s, :end_date_s, :customer_id_s, :status_s, :expedite_s,
                    :completion_percent_s, :zone_id_s, :sales_id_s, :payment_percent_s,
                    :as => :role_search_stats

                    
      belongs_to :customer, :class_name => 'Customerx::Customer'
      belongs_to :zone, :class_name => 'Authentify::Zone'
      belongs_to :sales, :class_name => 'Authentify::User'
      belongs_to :last_updated_by, :class_name => 'Authentify::User'
      belongs_to :project_manager, :class_name => 'Authentify::User'
      belongs_to :project_type, :class_name => 'Projectx::TypeDefinition'

      has_many :contracts, :class_name => "Projectx::Contract"
      accepts_nested_attributes_for :contracts, :allow_destroy => true
    
      validates :name, :presence => true,
                       :uniqueness => {:case_sensitive => false, :message => 'Duplicate project name'}
      validates :project_num, :presence => true, 
                              :uniqueness => {:case_sensitive => false, :message => 'Duplicated project num'}
      validates_presence_of :zone_id, :sales_id, :customer_id, :project_manager_id, :project_type_id, :start_date,
                            :end_date, :delivery_date

    def find_projects
      #return all qualified projects
      projects = Projectx::Project.scoped  #In Rails < 4 .all makes database call immediately, loads records and returns array. 
      #Instead use "lazy" scoped method which returns chainable ActiveRecord::Relation object
      projects = projects.where("id = ?", project_id_s) if project_id_s.present?
      projects = projects.where("name like ? ", "%#{keyword}%") if keyword.present?
      projects = projects.where('created_at > ?', start_date_s) if start_date_s.present?
      projects = projects.where('created_at < ?', end_date_s) if end_date_s.present?
      projects = projects.where("customer_id = ?", customer_id_s) if customer_id_s.present?
      projects = projects.where(:status => status_s) if status_s.present?
      projects = projects.where(:expedite => expedite_s) if expedite_s.present?
      projects = projects.where(:completion_percent => completion_percent_s) if completion_percent_s.present?
      projects = projects.where(:zone_id => zone_id_s) if zone_id_s.present?
      projects = projects.where("sales_id = ?", sales_id_s) if sales_id_s.present?
      projects = projects.where("payment_percent = ?", payment_percent_s) if payment_percent_s.present?
      projects
    end

  end
end
