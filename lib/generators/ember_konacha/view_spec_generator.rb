require 'generators/ember_konacha/base_helper'

module EmberKonacha
  module Generators
    class ViewSpecGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      def create_view
        template "specs/view_spec.js.coffee.erb", spec_target
      end

      protected

      include EmberKonacha::BaseHelper

      def folder
        'views'
      end

      def view_name
        "App.#{class_name}View"
      end
    end
  end
end