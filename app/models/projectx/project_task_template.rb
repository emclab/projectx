module Projectx
  class ProjectTaskTemplate < ActiveRecord::Base
    attr_accessible :active, :instruction, :last_updated_by_id, :name, :type_definition_id, :ranking_order, :task_templates_attributes, :as => :role_new
    attr_accessible :active, :instruction, :last_updated_by_id, :name, :type_definition_id, :ranking_order, :task_templates_attributes, :as => :role_update
    
    belongs_to :type_definition, :class_name => 'Projectx::TypeDefinition'
    belongs_to :last_updated_by, :class_name => 'Authentify::User' 
    has_many :task_templates, :class_name => 'Projectx::TaskTemplate'
    accepts_nested_attributes_for :task_templates, :allow_destroy => true  #data validate in task_template model
       
    validates :type_definition_id, :presence => true,
                                :numericality => {:greater_than => 0}
    validates :name, :presence => true,
                     :uniqueness => { :case_sensitive => false, :message => 'Duplicate entry' }  
  end
end
