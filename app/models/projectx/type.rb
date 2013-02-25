module Projectx
  class Type < ActiveRecord::Base
    attr_accessible :brief_note, :entity, :last_updated_by_id, :name
  end
end
