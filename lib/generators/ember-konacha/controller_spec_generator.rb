module EmberKonacha
  module Generators
    class ControllerSpecGenerator < Rails::Generators::NamedBase
      class_option  :type, type: :string, optional: true, default: 'array',
                    desc:   'The type of controller to test',
                    banner: 'controller type: (array, object, base)'


      def create_controller
        unless valid_type? type
          raise "Invalid Type, must be one of: #{valid_types}, was: #{type}"
        end

        template "specs/controller/#{type}_controller_spec.js.coffee.erb", "specs/javascripts/controllers/#{file_name}.js.coffee"
      end

      protected

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
        option[:type] || 'array'
      end
    end
  end
end
