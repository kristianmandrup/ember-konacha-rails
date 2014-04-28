require 'generators/ember_konacha/base_helper'

module EmberKonacha
  module Generators
    class ViewSpecGenerator < ::EmberKonacha::BaseHelper
      def create_file
        template 'view_spec'
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