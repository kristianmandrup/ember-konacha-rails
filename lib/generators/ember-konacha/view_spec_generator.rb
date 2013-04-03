module EmberKonacha
  module Generators
    class ViewSpecGenerator < Rails::Generators::NamedBase
      def create_view
        template "specs/view_spec.js.coffee.erb", "specs/javascripts/views/#{file_name}.js.coffee"
      end

      protected

      def model_name
        "App.#{class_name}View"
      end
    end
  end
end