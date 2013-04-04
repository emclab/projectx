module Projectx
  module ApplicationHelper
    ActionView::Base.default_form_builder = Projectx::FormBuilderWithMasking
    
    def custom_form_for(object, *args, &block)
      options = args.extract_options!
      simple_form_for(object, *(args << options.merge(builder: Projectx::FormBuilderWithMasking)), &block)
    end

=begin
    def has_action_right?(action, resource)
      return session[:user_privilege].has_action_right?(action, table, type)
    end
=end


  end

end

