module Projectx
  class Status < ActiveRecord::Base
    attr_accessible :brief_note, :for_what, :last_updated_by_id, :name
  end
end
