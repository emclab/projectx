module Projectx
  class ProjectStatus < ActiveRecord::Base
    attr_accessible :active, :brief_note, :last_updated_by_id, :name, :ranking_order, :as => :role_new
    attr_accessible :active, :brief_note, :last_updated_by_id, :name, :ranking_order, :as => :role_update
    
    has_many :projects, :class_name => "Projectx::Project"
    belongs_to :last_updated_by, :class_name => "Authentify::User"
    
    validates :name, :presence => true,
                     :uniqueness => {:case_sensitive => false, :message => 'Duplicate status name' }
  end
end
