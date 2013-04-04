module Projectx
  class TaskDefinition < ActiveRecord::Base
    attr_accessible :last_updated_by_id, :name, :ranking_order, :task_desp, :task_instruction, :active,
                    :as => :role_new

    attr_accessible :last_updated_by_id, :name, :ranking_order, :task_desp, :task_instruction, :active,
                    :as => :role_update

    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    
    validates_presence_of :name
    validates :name, :uniqueness => {:case_sensitive => false, :message => 'Duplicate name found!'}
    validates :last_updated_by_id, :presence => true,
                                   :numericality => {:greater_than => 0}

  end
end
