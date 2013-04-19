module Projectx
  module MiscDefinitionsHelper

    def return_misc_definitions(which_definition)
      Projectx::MiscDefinition.where(:active => true, :for_which => which_definition)
    end

  end
end
