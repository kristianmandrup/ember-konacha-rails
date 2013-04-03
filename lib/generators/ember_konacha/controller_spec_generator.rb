require 'active_support'
require 'generators/ember_konacha/base_helper'

module EmberKonacha
  module Generators
    class ControllerSpecGenerator < Rails::Generators::NamedBase
      class_option  :type, type: :string, aliases: ['t'],
                    desc:   'The type of controller to test',
                    banner: 'controller type: (array, object, base)'


      source_root File.expand_path('../templates', __FILE__)

      def create_controller
        say "Creating #{type_name} controller spec", :green
        template "specs/controller/#{type}_controller_spec.js.coffee.erb", spec_target
      end

      protected

      def type_name
        article = case type.to_sym
        when :array, :object
          "an"
        else
          "a"
        end
        "#{article} #{type}"
      end

      def validate_type!
        unless valid_type? type
          raise "Invalid Type, must be one of: #{valid_types}, was: #{type}"
        end
      end

      include EmberKonacha::BaseHelper

      def folder
        'controllers'
      end      

      def model_name
        "App.#{class_name}"
      end

      def array_controller_name
        "App.#{class_name.pluralize}Controller"
      end

      def controller_name
        "App.#{class_name}Controller"
      end

      def valid_type?
        valid_types.include? type.to_s
      end

      def valid_types
        %w{array object base}
      end

      def type
        @type ||= resolved_type || options[:type]
      end

      def resolved_type
        if options[:type].blank?
          return is_plural?(name) ? 'array' : 'object'
        end
      end

      def is_plural? str
        str.singularize.pluralize == str
      end

      def is_singular? str
        str.pluralize.singularize == str
      end      
    end
  end
end
