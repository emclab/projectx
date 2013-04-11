# encoding: utf-8
module Projectx
  class MiscDefinition < ActiveRecord::Base
    attr_accessor :active_noupdate
    
    attr_accessible :active, :brief_note, :for_which, :name, :ranking_order, :last_updated_by_id, :as => :role_new
    attr_accessible :active, :brief_note, :for_which, :name, :ranking_order, :last_updated_by_id, :as => :role_update
    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    
    validates_presence_of :name, :for_which
    validates :name, :uniqueness => {:case_sensitive => false, :message => '重名！'}
    validates :last_updated_by_id, :presence => true,
                                   :numericality => {:greater_than => 0}
  end
end
