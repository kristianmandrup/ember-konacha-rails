module EmberKonacha
  module Generators
    class HelperSpecGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      def create_model
        template "specs/helper_spec.js.coffee.erb", "specs/javascripts/helpers/#{file_name}.js.coffee"
      end

      protected

      def model_name
        "App.#{class_name}Helper"
      end
    end
  end
end