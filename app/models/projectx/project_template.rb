module Projectx
  class ProjectTemplate < ActiveRecord::Base
    attr_accessible :active, :instruction, :last_updated_by_id, :name, :project_type_id, :as => :role_new
    belongs_to :project_type, :class_name => 'Projectx::MiscDefinition'
    belongs_to :last_updated_by, :class_name => 'Authentify::User' 
    has_many :task_templates, :class_name => 'Projectx::TaskTemplate'
    accepts_nested_attributes_for :task_templates, :reject_if => proc {|task| task['task_definition_id'].blank? }, :allow_destroy => true
       
    validates :project_type_id, :presence => true,
                                :numericality => {:greater_than => 0}
    validates :name, :presence => true,
                     :uniqueness => { :case_sensitive => false, :message => 'Duplicate entry' }  
  end
end
