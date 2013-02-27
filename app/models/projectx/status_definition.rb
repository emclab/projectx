module Projectx
  class StatusDefinition < ActiveRecord::Base
    attr_accessible :active, :brief_note, :for_what, :last_updated_by_id, :name, :ranking_order
  end
end
