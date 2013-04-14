module Projectx
  class Project < ActiveRecord::Base


      attr_accessible :name, :project_num, :customer_id, :project_type_id, :project_desp, :start_date,
                      :end_date, :delivery_date, :estimated_delivery_date, :project_instruction, :project_manager_id,
                      :cancelled, :completed, :last_updated_by_id, :expedite, :contracts_attributes,
                      :customer_name_autocomplete,
                      :as => :role_new
                      
      attr_accessible :name, :project_num, :customer_id, :project_type_id, :project_desp, :start_date,
                      :end_date, :delivery_date, :estimated_delivery_date, :project_instruction, :project_manager_id,
                      :cancelled, :completed, :last_updated_by_id, :expedite, :contracts_attributes,
                      :customer_name_autocomplete,
                      :as => :role_update


      attr_accessor :project_id_s, :keyword, :start_date_s, :end_date_s, :customer_id_s, :status_s, :expedite_s,
                    :completion_percent_s, :zone_id_s, :sales_id_s, :payment_percent_s, :completion_percent

      attr_accessible :project_id_s, :keyword, :start_date_s, :end_date_s, :customer_id_s, :status_s, :expedite_s,
                    :completion_percent_s, :zone_id_s, :sales_id_s, :payment_percent_s,
                    :as => :role_search_stats

                    
      belongs_to :customer, :class_name => 'Customerx::Customer'
      #belongs_to :zone, :class_name => 'Authentify::Zone'
      #belongs_to :sales, :class_name => 'Authentify::User'
      belongs_to :last_updated_by, :class_name => 'Authentify::User'
      belongs_to :project_manager, :class_name => 'Authentify::User'
      belongs_to :project_type, :class_name => 'Projectx::MiscDefinition'
      has_many :logs, :class_name => 'Projectx::Log'
      has_many :tasks, :class_name => 'Projectx::Task'
      has_many :contracts, :class_name => "Projectx::Contract"
      accepts_nested_attributes_for :contracts, :allow_destroy => true
    
      validates :name, :presence => true,
                       :uniqueness => {:case_sensitive => false, :message => 'Duplicate project name'}
      validates :project_num, :presence => true, 
                              :uniqueness => {:case_sensitive => false, :message => 'Duplicated project num'}
      validates_presence_of :project_manager_id, :project_type_id, :start_date,
                            :end_date, :delivery_date
      validates :customer_id, :presence => true,
                              :numericality => {:greater_than => 0}
      #validates :sales_id, :presence => true,
        #                   :numericality => {:greater_than => 0}


      def customer_name_autocomplete
        self.customer.try(:name)
      end

      def customer_name_autocomplete=(name)
        self.customer = Customerx::Customer.find_by_name(name) if name.present?
      end



    def self.find_projects(projects, params)
      #return all qualified projects
      #projects = Projectx::Project.scoped  #In Rails < 4 .all makes database call immediately, loads records and returns array.
      #Instead use "lazy" scoped method which returns chainable ActiveRecord::Relation object
      projects = projects.where("id = ?", params[:projectx_projects][:project_id_s]) if params[:projectx_projects][:project_id_s].present?
      projects = projects.where("name like ? ", "%#{params[:projectx_projects][:keyword]}%") if params[:projectx_projects][:keyword].present?
      projects = projects.where('created_at > ?', params[:projectx_projects][:start_date_s]) if params[:projectx_projects][:start_date_s].present?
      projects = projects.where('created_at < ?', params[:projectx_projects][:end_date_s]) if params[:projectx_projects][:end_date_s].present?
      projects = projects.where("customer_id = ?", params[:projectx_projects][:customer_id_s] ) if params[:projectx_projects][:customer_id_s].present?
      projects = projects.where(:status => params[:projectx_projects][:status_s]) if params[:projectx_projects][:status_s].present?
      projects = projects.where(:expedite => params[:projectx_projects][:expedite_s]) if params[:projectx_projects][:expedite_s].present?
      projects = projects.where(:completion_percent => params[:projectx_projects][:completion_percent_s]) if params[:projectx_projects][:completion_percent_s].present?
      #projects = projects.where(:zone_id => params[:projectx_projects][:zone_id_s]) if params[:projectx_projects][:zone_id_s].present?
      #projects = projects.where("sales_id = ?", params[:projectx_projects][:sales_id_s]) if params[:projectx_projects][:sales_id_s].present?
      #projects = projects.where("payment_percent = ?", params[:projectx_projects][:payment_percent_s]) if params[:projectx_projects][:payment_percent_s].present?
      projects
    end

  end
end
