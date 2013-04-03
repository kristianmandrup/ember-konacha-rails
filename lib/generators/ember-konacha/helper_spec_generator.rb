module EmberKonacha
  module Generators
    class ModelSpecGenerator < Rails::Generators::NamedBase
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