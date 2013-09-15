module Projectx
  class TaskDefinition < ActiveRecord::Base
    
    attr_accessor :active_noupdate
    attr_accessible :last_updated_by_id, :name, :ranking_order, :task_desp, :task_instruction, :active,
                    :active_noupdate,
                    :as => :role_new

    attr_accessible :last_updated_by_id, :name, :ranking_order, :task_desp, :task_instruction, :active,
                    :active_noupdate,
                    :as => :role_update
                    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    has_many :tasks, :class_name => 'Projectx::Task'
    
    validates_presence_of :name
    validates :name, :uniqueness => {:case_sensitive => false, :message => I18n.t('Duplicate Name!')}
    validates :last_updated_by_id, :presence => true,
                                   :numericality => {:greater_than => 0}

  end
end
