# encoding: utf-8
module Projectx
  class TypeDefinition < ActiveRecord::Base
    attr_accessor :active_noupdate
    attr_accessible :active, :brief_note, :last_updated_by_id, :name, :ranking_order,
                    :as => :role_new
    attr_accessible :active, :brief_note, :last_updated_by_id, :name, :ranking_order,
                    :as => :role_update
                    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    has_many :project_task_templates, :class_name => 'Projectx::ProjectTaskTemplate'
    
    validates :name, :presence => true,
                     :uniqueness => {:case_sensitive => false, :message => '重名！'}
  end
end
