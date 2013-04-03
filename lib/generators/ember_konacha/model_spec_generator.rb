module EmberKonacha
  module Generators
    class ModelSpecGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      def create_model
        template "specs/model_spec.js.coffee.erb", "specs/javascripts/models/#{file_name}.js.coffee"
      end

      protected

      def model_name
        "App.#{class_name}"
      end
    end
  end
end