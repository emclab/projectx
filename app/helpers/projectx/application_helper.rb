module Projectx
  module ApplicationHelper
    include Commonx::CommonxHelper
    include Projectx::ProjectxHelper
    include Customerx::CustomerxHelper
    #ActionView::Base.default_form_builder = Projectx::FormBuilderWithMasking   

    #def return_task_status
    #  Commonx::MiscDefinition.where(:active => true).where(:for_which => 'task_status').order('ranking_index')
    #end
  end

end

