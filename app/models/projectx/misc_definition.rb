# encoding: utf-8
module Projectx
  class MiscDefinition < ActiveRecord::Base
    attr_accessor :active_noupdate
    
    attr_accessible :active, :brief_note, :for_which, :name, :ranking_order, :last_updated_by_id, :for_which, :as => :role_new
    attr_accessible :active, :brief_note, :for_which, :name, :ranking_order, :last_updated_by_id, :for_which, :as => :role_update
    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    #has_many :project_templates, :class_name => 'Projectx::ProjectTemplate'
    
    validates_presence_of :for_which
    validates :name, :presence => true,
                     :uniqueness => {:scope => :for_which, :case_sensitive => false, :message => '重名！'}
  
  end
end
