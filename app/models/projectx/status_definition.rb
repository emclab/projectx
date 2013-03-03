#encoding: utf-8
module Projectx
  class StatusDefinition < ActiveRecord::Base
    attr_accessible :active, :brief_note, :for_what, :last_updated_by_id, :name, :ranking_order, :as => :role_new
    attr_accessible :active, :brief_note, :for_what, :last_updated_by_id, :name, :ranking_order, :as => :role_update
    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    
    validates_presence_of :name, :for_what
    validates :name, :uniqueness => {:case_sensitive => false, :message => '重名！'}
    validates :last_updated_by_id, :presence => true,
                                   :numericality => {:greater_than => 0}
  end
end
