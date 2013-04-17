module Projectx
  class ProjectTaskTemplate < ActiveRecord::Base
    attr_accessible :active, :instruction, :last_updated_by_id, :name, :type_definition_id
  end
end
