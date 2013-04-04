module Projectx

  class FormBuilderWithMasking < SimpleForm::FormBuilder

    def input(attribute_name, options={}, &block)
      options[:input_html] ||= {}
      options[:input_html][:value] = object.send(attribute_name)
      super(attribute_name, options, &block)
    end

  def text_field(method, options = {})
      if object.has_attribute?(method)
        super
      else
        return ""
      end

    end


    helpers = field_helpers + %w(time_zone_select date_select) - %w(hidden_field fields_for label)
    helpers.each do |helper|
      define_method helper do |field, *args|
        options = args.detect{ |a| a.is_a?(Hash) } || {}
        # decorate your fields here
        puts options
      end
    end

  end

end

