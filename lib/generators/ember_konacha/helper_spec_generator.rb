require 'generators/ember_konacha/base_helper'

module EmberKonacha
  module Generators
    class HelperSpecGenerator < ::EmberKonacha::BaseHelper
      def create_file
        template 'helper_spec'
      end

      protected

      include EmberKonacha::BaseHelper

      def folder
        'helpers'
      end      

      def helper_name
        "App.#{class_name}Helper"
      end
    end
  end
end